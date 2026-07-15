import { useCallback, useEffect, useState } from "react";
import { api, type Producer, type ValidationMessage } from "../api";
import { ErrorMessage, Field, FormActions, NumberInput, SuccessMessage } from "../components/Form";
import { printPdfInBrowser } from "../utils/print";

const today = new Date().toISOString().slice(0, 10);

const emptyQty = {
  qty_extra: 0, qty_class1: 0, qty_class2: 0, qty_class3: 0,
  crates_prep: 0, crates_class1: 0, crates_class2: 0, crates_class3: 0,
  packaging_taken: 0, packaging_returned: 0,
};

function ValidationBox({ messages }: { messages: ValidationMessage[] }) {
  if (!messages.length) return null;
  return (
    <div className="validation-box">
      {messages.map((m) => (
        <p key={m.code} className={`validation-msg validation-${m.level}`}>{m.message}</p>
      ))}
    </div>
  );
}

export function FruitPurchasePage() {
  const [purchases, setPurchases] = useState<Awaited<ReturnType<typeof api.listPurchases>>>([]);
  const [producers, setProducers] = useState<Producer[]>([]);
  const [producerHint, setProducerHint] = useState(false);
  const [fruits, setFruits] = useState<Awaited<ReturnType<typeof api.listFruits>>>([]);
  const [locations, setLocations] = useState<Awaited<ReturnType<typeof api.listLocations>>>([]);
  const [autoPrint, setAutoPrint] = useState(true);
  const [form, setForm] = useState({
    location_code: "", producer_code: "", fruit_code: "",
    purchase_date: today,
    ...emptyQty,
    crate_weight_100g: 5,
    document_no: "",
  });
  const [warnings, setWarnings] = useState<ValidationMessage[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const load = useCallback(() => {
    api.listLocations().then(setLocations);
    api.listFruits().then(setFruits);
    api.listProducers().then((all) => {
      const sorted = form.location_code
        ? [
            ...all.filter((p) => p.location_code === form.location_code),
            ...all.filter((p) => p.location_code !== form.location_code),
          ]
        : all;
      setProducers(sorted);
      setProducerHint(
        Boolean(form.location_code) &&
        all.some((p) => p.location_code !== form.location_code),
      );
    });
    api.listPurchases({ date_from: form.purchase_date, date_to: form.purchase_date }).then(setPurchases).catch((e: Error) => setError(e.message));
  }, [form.purchase_date, form.location_code]);

  useEffect(() => { load(); }, [load]);

  useEffect(() => {
    if (!form.location_code && locations.length) {
      setForm((f) => ({ ...f, location_code: locations[0].code }));
    }
    if (!form.fruit_code && fruits.length) {
      setForm((f) => ({ ...f, fruit_code: fruits[0].code }));
    }
  }, [locations, fruits, form.location_code, form.fruit_code]);

  useEffect(() => {
    if (!form.producer_code || !form.fruit_code) { setWarnings([]); return; }
    const t = setTimeout(() => {
      api.validatePurchase(form).then(setWarnings).catch(() => setWarnings([]));
    }, 300);
    return () => clearTimeout(t);
  }, [form]);

  function setNum(key: keyof typeof form, value: number) {
    setForm((f) => ({ ...f, [key]: value }));
  }

  function setStr(key: keyof typeof form, value: string) {
    setForm((f) => ({ ...f, [key]: value }));
  }

  async function printOtkupReceipt(purchaseId: number, locationCode: string) {
    const params = { purchase_id: purchaseId, location_code: locationCode || undefined };
    try {
      await api.printOtkupReceipt(params);
    } catch {
      await printPdfInBrowser(api.otkupReceiptPdfUrl(params));
    }
  }

  async function save() {
    setError(null); setSuccess(null);
    if (!form.producer_code || !form.fruit_code) {
      setError("Izaberite proizvođača i voće.");
      return;
    }
    const blocking = warnings.filter((w) => w.level === "error");
    if (blocking.length) {
      setError(blocking[0].message);
      return;
    }
    try {
      const res = await api.createPurchase(form);
      setSuccess("Otkup sačuvan.");
      if (res.warnings.length) setWarnings(res.warnings);
      const savedLocation = form.location_code;
      const savedPurchaseId = res.purchase.id;
      setForm((f) => ({
        ...f,
        ...emptyQty,
        document_no: "",
        producer_code: f.producer_code,
      }));
      load();
      if (autoPrint) {
        try {
          await printOtkupReceipt(savedPurchaseId, savedLocation);
        } catch (e) {
          const msg = e instanceof Error ? e.message : "Štampanje nije uspelo.";
          setSuccess(`Otkup sačuvan. ${msg}`);
        }
      }
    } catch (e) { setError(e instanceof Error ? e.message : "Greška"); }
  }

  const totalCrates = form.crates_prep + form.crates_class1 + form.crates_class2 + form.crates_class3;
  const totalKg = form.qty_extra + form.qty_class1 + form.qty_class2 + form.qty_class3;
  const netKg = Math.max(totalKg - totalCrates * form.crate_weight_100g * 0.1, 0);

  const locationName = (code: string) => locations.find((l) => l.code === code)?.name ?? code;

  return (
    <div className="panel">
      <h2>Otkup voća</h2>
      <p className="subtitle">Unos sa proverama kao u starom programu. Posle čuvanja štampa se otkupni list za uneti otkup.</p>
      <ValidationBox messages={warnings} />

      <div className="form-grid">
        <Field label="Otkupno mesto">
          <select value={form.location_code} onChange={(e) => setStr("location_code", e.target.value)}>
            {locations.map((l) => <option key={l.id} value={l.code}>{l.name}</option>)}
          </select>
        </Field>
        <Field label="Proizvođač *">
          <select value={form.producer_code} onChange={(e) => setStr("producer_code", e.target.value)}>
            <option value="">— izaberite —</option>
            {producers.map((p) => (
              <option key={p.id} value={p.code}>{p.name} ({p.code}) — {locationName(p.location_code)}</option>
            ))}
          </select>
        </Field>
        <Field label="Voće *">
          <select value={form.fruit_code} onChange={(e) => setStr("fruit_code", e.target.value)}>
            {fruits.map((f) => <option key={f.id} value={f.code}>{f.name}</option>)}
          </select>
        </Field>
        <Field label="Datum"><input type="date" value={form.purchase_date} onChange={(e) => setStr("purchase_date", e.target.value)} /></Field>
        <Field label="Dokument"><input value={form.document_no} placeholder="broj dokumenta" onChange={(e) => setStr("document_no", e.target.value)} /></Field>
      </div>

      {producerHint && (
        <p className="hint">Prikazani su svi proizvođači — proverite otkupno mesto kod onih sa drugim mestom u šifarniku.</p>
      )}

      <h3>Količine (kg)</h3>
      <div className="form-grid">
        <Field label="Prep. klasa"><NumberInput value={form.qty_extra} onChange={(v) => setNum("qty_extra", v)} step="0.01" /></Field>
        <Field label="I klasa"><NumberInput value={form.qty_class1} onChange={(v) => setNum("qty_class1", v)} step="0.01" /></Field>
        <Field label="II klasa"><NumberInput value={form.qty_class2} onChange={(v) => setNum("qty_class2", v)} step="0.01" /></Field>
        <Field label="III klasa"><NumberInput value={form.qty_class3} onChange={(v) => setNum("qty_class3", v)} step="0.01" /></Field>
      </div>

      <h3>Gajbe</h3>
      <div className="form-grid">
        <Field label="Prep. gajbe"><NumberInput value={form.crates_prep} onChange={(v) => setNum("crates_prep", v)} /></Field>
        <Field label="I klasa gajbe"><NumberInput value={form.crates_class1} onChange={(v) => setNum("crates_class1", v)} /></Field>
        <Field label="II klasa gajbe"><NumberInput value={form.crates_class2} onChange={(v) => setNum("crates_class2", v)} /></Field>
        <Field label="III klasa gajbe"><NumberInput value={form.crates_class3} onChange={(v) => setNum("crates_class3", v)} /></Field>
        <Field label="Težina gajbe (×100g)"><NumberInput value={form.crate_weight_100g} onChange={(v) => setNum("crate_weight_100g", v)} placeholder="5" /></Field>
        <Field label="Neto kg (posle tare)"><input readOnly value={netKg.toFixed(2)} /></Field>
      </div>

      <h3>Ambalaža</h3>
      <div className="form-grid">
        <Field label="Amb. uzeta"><NumberInput value={form.packaging_taken} onChange={(v) => setNum("packaging_taken", v)} /></Field>
        <Field label="Amb. vraćena"><NumberInput value={form.packaging_returned} onChange={(v) => setNum("packaging_returned", v)} /></Field>
      </div>

      <label className="checkbox-row">
        <input type="checkbox" checked={autoPrint} onChange={(e) => setAutoPrint(e.target.checked)} />
        Automatski štampaj otkupni list posle čuvanja
      </label>

      <FormActions onSave={save} saveLabel="Sačuvaj otkup" />
      <ErrorMessage message={error} /><SuccessMessage message={success} />

      <h3>Otkupi za {form.purchase_date}</h3>
      <table className="data-table">
        <thead><tr><th>Datum</th><th>Proizvođač</th><th>Voće</th><th>Količina</th><th>Vrednost</th></tr></thead>
        <tbody>
          {purchases.map((p) => (
            <tr key={p.id}>
              <td>{p.purchase_date}</td><td>{p.producer_name}</td><td>{p.fruit_name}</td>
              <td>{(p.qty_extra + p.qty_class1 + p.qty_class2 + p.qty_class3).toFixed(2)} kg</td>
              <td>{p.total_value?.toFixed(2)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
