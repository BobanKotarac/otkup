import { useCallback, useEffect, useState } from "react";
import { api, type Good, type GoodsDebit, type Producer, type PurchaseLocation } from "../api";
import { ErrorMessage, Field, FormActions, SuccessMessage } from "../components/Form";

const today = new Date().toISOString().slice(0, 10);

export function GoodsDebitPage() {
  const [debits, setDebits] = useState<GoodsDebit[]>([]);
  const [producers, setProducers] = useState<Producer[]>([]);
  const [goods, setGoods] = useState<Good[]>([]);
  const [locations, setLocations] = useState<PurchaseLocation[]>([]);
  const [form, setForm] = useState({
    location_code: "", producer_code: "", good_code: "",
    debit_date: today, quantity: 0, document_no: "",
  });
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const load = useCallback(() => {
    api.listLocations().then(setLocations);
    api.listGoods().then(setGoods);
    api.listDebits().then(setDebits).catch((e: Error) => setError(e.message));
  }, []);

  useEffect(() => { load(); }, [load]);

  useEffect(() => {
    api.listProducers().then((all) => {
      if (!form.location_code) { setProducers(all); return; }
      const filtered = all.filter((p) => p.location_code === form.location_code);
      setProducers(filtered.length > 0 ? filtered : all);
    });
  }, [form.location_code]);

  useEffect(() => {
    if (!form.location_code && locations.length) setForm((f) => ({ ...f, location_code: locations[0].code }));
    if (!form.good_code && goods.length) setForm((f) => ({ ...f, good_code: goods[0].code }));
  }, [locations, goods, form.location_code, form.good_code]);

  function set(key: string, value: string | number) {
    setForm((f) => ({ ...f, [key]: key === "quantity" ? Number(value) : value }));
  }

  async function save() {
    setError(null); setSuccess(null);
    if (!form.producer_code || !form.good_code) { setError("Izaberite proizvođača i robu."); return; }
    try {
      await api.createDebit(form);
      setSuccess("Zaduženje sačuvano.");
      setForm((f) => ({ ...f, quantity: 0, document_no: "" }));
      load();
    } catch (e) { setError(e instanceof Error ? e.message : "Greška"); }
  }

  return (
    <div className="panel">
      <h2>Unos zaduženja</h2>
      <p className="subtitle">Zaduženje proizvođača robom.</p>
      <div className="form-grid">
        <Field label="Otkupno mesto">
          <select value={form.location_code} onChange={(e) => set("location_code", e.target.value)}>
            {locations.map((l) => <option key={l.id} value={l.code}>{l.name}</option>)}
          </select>
        </Field>
        <Field label="Proizvođač *">
          <select value={form.producer_code} onChange={(e) => set("producer_code", e.target.value)}>
            <option value="">— izaberite —</option>
            {producers.map((p) => <option key={p.id} value={p.code}>{p.name}</option>)}
          </select>
        </Field>
        <Field label="Roba *">
          <select value={form.good_code} onChange={(e) => set("good_code", e.target.value)}>
            {goods.map((g) => <option key={g.id} value={g.code}>{g.name}</option>)}
          </select>
        </Field>
        <Field label="Datum"><input type="date" value={form.debit_date} onChange={(e) => set("debit_date", e.target.value)} /></Field>
        <Field label="Količina"><input type="number" step="0.01" value={form.quantity} onChange={(e) => set("quantity", e.target.value)} /></Field>
        <Field label="Dokument"><input value={form.document_no} onChange={(e) => set("document_no", e.target.value)} /></Field>
      </div>
      <FormActions onSave={save} saveLabel="Sačuvaj zaduženje" />
      <ErrorMessage message={error} /><SuccessMessage message={success} />
      <h3>Poslednja zaduženja</h3>
      <table className="data-table">
        <thead><tr><th>Datum</th><th>Proizvođač</th><th>Roba</th><th>Kol.</th><th>Vrednost</th></tr></thead>
        <tbody>
          {debits.slice(0, 20).map((d) => (
            <tr key={d.id}>
              <td>{d.debit_date}</td><td>{d.producer_name}</td><td>{d.good_name}</td>
              <td>{d.quantity}</td><td>{d.total_value?.toFixed(2)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
