import { useCallback, useEffect, useState } from "react";
import { api, type ValidationMessage } from "../api";
import { ErrorMessage, Field, FormActions, SuccessMessage } from "../components/Form";

const today = new Date().toISOString().slice(0, 10);

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
  const [producers, setProducers] = useState<Awaited<ReturnType<typeof api.listProducers>>>([]);
  const [fruits, setFruits] = useState<Awaited<ReturnType<typeof api.listFruits>>>([]);
  const [locations, setLocations] = useState<Awaited<ReturnType<typeof api.listLocations>>>([]);
  const [form, setForm] = useState({
    location_code: "", producer_code: "", fruit_code: "",
    purchase_date: today,
    qty_extra: 0, qty_class1: 0, qty_class2: 0, qty_class3: 0,
    crates_prep: 0, crates_class1: 0, crates_class2: 0, crates_class3: 0,
    crate_weight_100g: 5,
    packaging_taken: 0, packaging_returned: 0,
    document_no: "",
  });
  const [warnings, setWarnings] = useState<ValidationMessage[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const load = useCallback(() => {
    api.listLocations().then(setLocations);
    api.listFruits().then(setFruits);
    api.listPurchases().then(setPurchases).catch((e: Error) => setError(e.message));
  }, []);

  useEffect(() => { load(); }, [load]);

  useEffect(() => {
    if (form.location_code) api.listProducers(form.location_code).then(setProducers);
    else setProducers([]);
  }, [form.location_code]);

  useEffect(() => {
    if (!form.location_code && locations.length) setForm((f) => ({ ...f, location_code: locations[0].code }));
    if (!form.fruit_code && fruits.length) setForm((f) => ({ ...f, fruit_code: fruits[0].code }));
  }, [locations, fruits, form.location_code, form.fruit_code]);

  useEffect(() => {
    if (!form.producer_code || !form.fruit_code) { setWarnings([]); return; }
    const t = setTimeout(() => {
      api.validatePurchase(form).then(setWarnings).catch(() => setWarnings([]));
    }, 300);
    return () => clearTimeout(t);
  }, [form]);

  function set(key: string, value: string | number) {
    setForm((f) => ({
      ...f,
      [key]: typeof f[key as keyof typeof f] === "number" && (key.startsWith("qty") || key.startsWith("crates") || key.includes("packaging") || key.includes("crate_weight") || key === "document_no")
        ? (key === "document_no" ? value : Number(value))
        : value,
    }));
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
      setForm((f) => ({
        ...f,
        qty_extra: 0, qty_class1: 0, qty_class2: 0, qty_class3: 0,
        crates_prep: 0, crates_class1: 0, crates_class2: 0, crates_class3: 0,
        packaging_taken: 0, packaging_returned: 0, document_no: "",
      }));
      load();
    } catch (e) { setError(e instanceof Error ? e.message : "Greška"); }
  }

  const totalCrates = form.crates_prep + form.crates_class1 + form.crates_class2 + form.crates_class3;
  const totalKg = form.qty_extra + form.qty_class1 + form.qty_class2 + form.qty_class3;
  const netKg = Math.max(totalKg - totalCrates * form.crate_weight_100g * 0.1, 0);

  return (
    <div className="panel">
      <h2>Otkup voća</h2>
      <p className="subtitle">Unos sa proverama kao u starom programu (dupli otkup, težina gajbi).</p>
      <ValidationBox messages={warnings} />

      <div className="form-grid">
        <Field label="Otkupno mesto">
          <select value={form.location_code} onChange={(e) => set("location_code", e.target.value)}>
            {locations.map((l) => <option key={l.id} value={l.code}>{l.name}</option>)}
          </select>
        </Field>
        <Field label="Proizvođač *">
          <select value={form.producer_code} onChange={(e) => set("producer_code", e.target.value)}>
            <option value="">— izaberite —</option>
            {producers.map((p) => <option key={p.id} value={p.code}>{p.name} ({p.code})</option>)}
          </select>
        </Field>
        <Field label="Voće *">
          <select value={form.fruit_code} onChange={(e) => set("fruit_code", e.target.value)}>
            {fruits.map((f) => <option key={f.id} value={f.code}>{f.name}</option>)}
          </select>
        </Field>
        <Field label="Datum"><input type="date" value={form.purchase_date} onChange={(e) => set("purchase_date", e.target.value)} /></Field>
        <Field label="Dokument"><input value={String(form.document_no)} onChange={(e) => set("document_no", e.target.value)} /></Field>
      </div>

      <h3>Količine (kg)</h3>
      <div className="form-grid">
        <Field label="Prep. klasa"><input type="number" step="0.01" value={form.qty_extra} onChange={(e) => set("qty_extra", e.target.value)} /></Field>
        <Field label="I klasa"><input type="number" step="0.01" value={form.qty_class1} onChange={(e) => set("qty_class1", e.target.value)} /></Field>
        <Field label="II klasa"><input type="number" step="0.01" value={form.qty_class2} onChange={(e) => set("qty_class2", e.target.value)} /></Field>
        <Field label="III klasa"><input type="number" step="0.01" value={form.qty_class3} onChange={(e) => set("qty_class3", e.target.value)} /></Field>
      </div>

      <h3>Gajbe</h3>
      <div className="form-grid">
        <Field label="Prep. gajbe"><input type="number" value={form.crates_prep} onChange={(e) => set("crates_prep", e.target.value)} /></Field>
        <Field label="I klasa gajbe"><input type="number" value={form.crates_class1} onChange={(e) => set("crates_class1", e.target.value)} /></Field>
        <Field label="II klasa gajbe"><input type="number" value={form.crates_class2} onChange={(e) => set("crates_class2", e.target.value)} /></Field>
        <Field label="III klasa gajbe"><input type="number" value={form.crates_class3} onChange={(e) => set("crates_class3", e.target.value)} /></Field>
        <Field label="Težina gajbe (×100g)"><input type="number" value={form.crate_weight_100g} onChange={(e) => set("crate_weight_100g", e.target.value)} /></Field>
        <Field label="Neto kg (posle tare)"><input readOnly value={netKg.toFixed(2)} /></Field>
      </div>

      <h3>Ambalaža</h3>
      <div className="form-grid">
        <Field label="Amb. uzeta"><input type="number" value={form.packaging_taken} onChange={(e) => set("packaging_taken", e.target.value)} /></Field>
        <Field label="Amb. vraćena"><input type="number" value={form.packaging_returned} onChange={(e) => set("packaging_returned", e.target.value)} /></Field>
      </div>

      <FormActions onSave={save} saveLabel="Sačuvaj otkup" />
      <ErrorMessage message={error} /><SuccessMessage message={success} />

      <h3>Poslednji otkupi</h3>
      <table className="data-table">
        <thead><tr><th>Datum</th><th>Proizvođač</th><th>Voće</th><th>Količina</th><th>Vrednost</th></tr></thead>
        <tbody>
          {purchases.slice(0, 20).map((p) => (
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
