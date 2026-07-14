import { useCallback, useEffect, useState } from "react";
import { api, type Producer, type PurchaseLocation } from "../api";
import { ErrorMessage, Field, FormActions, SuccessMessage } from "../components/Form";

export function ProducersPage() {
  const [items, setItems] = useState<Producer[]>([]);
  const [locations, setLocations] = useState<PurchaseLocation[]>([]);
  const [form, setForm] = useState({
    name: "", location_code: "", personal_id: "", contract: "",
    bank_account: "", parcel_area: 0, vat_registered: "N", category: "",
  });
  const [editId, setEditId] = useState<number | null>(null);
  const [filterLocation, setFilterLocation] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const load = useCallback(() => {
    api.listLocations().then(setLocations);
    api.listProducers(filterLocation || undefined).then(setItems).catch((e: Error) => setError(e.message));
  }, [filterLocation]);

  useEffect(() => { load(); }, [load]);

  function set(key: string, value: string | number) {
    setForm((f) => ({ ...f, [key]: value }));
  }

  function resetForm() {
    setForm({ name: "", location_code: locations[0]?.code ?? "", personal_id: "", contract: "", bank_account: "", parcel_area: 0, vat_registered: "N", category: "" });
    setEditId(null);
  }

  useEffect(() => {
    if (!form.location_code && locations.length) set("location_code", locations[0].code);
  }, [locations, form.location_code]);

  async function save() {
    setError(null); setSuccess(null);
    try {
      if (editId) {
        await api.updateProducer(editId, form);
        setSuccess("Proizvođač izmenjen.");
      } else {
        await api.createProducer(form);
        setSuccess("Proizvođač dodat.");
      }
      resetForm(); load();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Greška");
    }
  }

  function startEdit(item: Producer) {
    setEditId(item.id);
    setForm({
      name: item.name, location_code: item.location_code,
      personal_id: item.personal_id ?? "", contract: item.contract ?? "",
      bank_account: item.bank_account ?? "", parcel_area: item.parcel_area ?? 0,
      vat_registered: item.vat_registered ?? "N", category: item.category ?? "",
    });
  }

  return (
    <div className="panel">
      <h2>Proizvođači</h2>
      <p className="subtitle">Dodajte proizvođače po otkupnom mestu. Šifra se dodeljuje automatski.</p>

      {locations.length === 0 && <div className="notice">Prvo dodajte otkupna mesta.</div>}

      <div className="form-grid">
        <Field label="Otkupno mesto *">
          <select value={form.location_code} onChange={(e) => set("location_code", e.target.value)}>
            {locations.map((l) => <option key={l.id} value={l.code}>{l.name} ({l.code})</option>)}
          </select>
        </Field>
        <Field label="Ime i prezime *"><input value={form.name} onChange={(e) => set("name", e.target.value)} /></Field>
        <Field label="JMBG"><input value={form.personal_id} onChange={(e) => set("personal_id", e.target.value)} /></Field>
        <Field label="Ugovor"><input value={form.contract} onChange={(e) => set("contract", e.target.value)} /></Field>
        <Field label="Tekući račun"><input value={form.bank_account} onChange={(e) => set("bank_account", e.target.value)} /></Field>
        <Field label="PDV (D/N)"><input value={form.vat_registered} onChange={(e) => set("vat_registered", e.target.value)} maxLength={1} /></Field>
      </div>
      <FormActions onSave={save} onCancel={editId ? resetForm : undefined} saveLabel={editId ? "Izmeni" : "Dodaj"} />
      <ErrorMessage message={error} />
      <SuccessMessage message={success} />

      <div className="filter-row">
        <label>Filtriraj po mestu:
          <select value={filterLocation} onChange={(e) => setFilterLocation(e.target.value)}>
            <option value="">Sva mesta</option>
            {locations.map((l) => <option key={l.id} value={l.code}>{l.name}</option>)}
          </select>
        </label>
      </div>

      <table className="data-table">
        <thead><tr><th>Šifra</th><th>Ime</th><th>Mesto</th><th>JMBG</th><th></th></tr></thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.id}>
              <td>{item.code}</td><td>{item.name}</td><td>{item.location_code}</td><td>{item.personal_id}</td>
              <td className="actions"><button type="button" onClick={() => startEdit(item)}>Izmeni</button></td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
