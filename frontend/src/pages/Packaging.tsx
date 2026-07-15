import { useCallback, useEffect, useState } from "react";
import { api, type PackagingRecord, type Producer, type PurchaseLocation } from "../api";
import { ErrorMessage, Field, FormActions, SuccessMessage } from "../components/Form";

const today = new Date().toISOString().slice(0, 10);

export function PackagingPage() {
  const [records, setRecords] = useState<PackagingRecord[]>([]);
  const [producers, setProducers] = useState<Producer[]>([]);
  const [locations, setLocations] = useState<PurchaseLocation[]>([]);
  const [form, setForm] = useState({
    location_code: "", producer_code: "", transaction_date: today,
    taken: 0, returned: 0, document_no: "",
  });
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const load = useCallback(() => {
    api.listLocations().then(setLocations);
    api.listPackaging().then(setRecords).catch((e: Error) => setError(e.message));
  }, []);

  useEffect(() => { load(); }, [load]);

  useEffect(() => {
    api.listProducers().then((all) => {
      const sorted = form.location_code
        ? [
            ...all.filter((p) => p.location_code === form.location_code),
            ...all.filter((p) => p.location_code !== form.location_code),
          ]
        : all;
      setProducers(sorted);
    });
  }, [form.location_code]);

  useEffect(() => {
    if (!form.location_code && locations.length) setForm((f) => ({ ...f, location_code: locations[0].code }));
  }, [locations, form.location_code]);

  function set(key: string, value: string | number) {
    setForm((f) => ({ ...f, [key]: key === "taken" || key === "returned" ? Number(value) : value }));
  }

  async function save() {
    setError(null); setSuccess(null);
    if (!form.producer_code) { setError("Izaberite proizvođača."); return; }
    try {
      await api.createPackaging(form);
      setSuccess("Ambalaža sačuvana.");
      setForm((f) => ({ ...f, taken: 0, returned: 0, document_no: "" }));
      load();
    } catch (e) { setError(e instanceof Error ? e.message : "Greška"); }
  }

  return (
    <div className="panel">
      <h2>Ambalaža</h2>
      <p className="subtitle">Unos uzete i vraćene ambalaže.</p>
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
        <Field label="Datum"><input type="date" value={form.transaction_date} onChange={(e) => set("transaction_date", e.target.value)} /></Field>
        <Field label="Amb. uzeta"><input type="number" step="1" value={form.taken} onChange={(e) => set("taken", e.target.value)} /></Field>
        <Field label="Amb. vraćena"><input type="number" step="1" value={form.returned} onChange={(e) => set("returned", e.target.value)} /></Field>
        <Field label="Dokument"><input value={form.document_no} onChange={(e) => set("document_no", e.target.value)} /></Field>
      </div>
      <FormActions onSave={save} saveLabel="Sačuvaj" />
      <ErrorMessage message={error} /><SuccessMessage message={success} />
      <h3>Poslednji unosi</h3>
      <table className="data-table">
        <thead><tr><th>Datum</th><th>Proizvođač</th><th>Uzeta</th><th>Vraćena</th></tr></thead>
        <tbody>
          {records.slice(0, 20).map((r) => (
            <tr key={r.id}>
              <td>{r.transaction_date}</td><td>{r.producer_name}</td><td>{r.taken}</td><td>{r.returned}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
