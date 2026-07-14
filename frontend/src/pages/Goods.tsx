import { useCallback, useEffect, useState } from "react";
import { api, type Good } from "../api";
import { ErrorMessage, Field, FormActions, SuccessMessage } from "../components/Form";

export function GoodsPage() {
  const [items, setItems] = useState<Good[]>([]);
  const [form, setForm] = useState({ name: "", price: 0, unit: "", vat_rate: 0 });
  const [editId, setEditId] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const load = useCallback(() => {
    api.listGoods().then(setItems).catch((e: Error) => setError(e.message));
  }, []);

  useEffect(() => { load(); }, [load]);

  function set(key: string, value: string | number) {
    setForm((f) => ({ ...f, [key]: key === "name" || key === "unit" ? value : Number(value) }));
  }

  function resetForm() { setForm({ name: "", price: 0, unit: "", vat_rate: 0 }); setEditId(null); }

  async function save() {
    setError(null); setSuccess(null);
    try {
      if (editId) { await api.updateGood(editId, form); setSuccess("Roba izmenjena."); }
      else { await api.createGood(form); setSuccess("Roba dodata."); }
      resetForm(); load();
    } catch (e) { setError(e instanceof Error ? e.message : "Greška"); }
  }

  function startEdit(item: Good) {
    setEditId(item.id);
    setForm({ name: item.name, price: item.price, unit: item.unit, vat_rate: item.vat_rate });
  }

  return (
    <div className="panel">
      <h2>Roba</h2>
      <p className="subtitle">Šifarnik robe koja se zadužuje proizvođačima.</p>
      <div className="form-grid">
        <Field label="Naziv *"><input value={form.name} onChange={(e) => set("name", e.target.value)} /></Field>
        <Field label="Cena"><input type="number" step="0.01" value={form.price} onChange={(e) => set("price", e.target.value)} /></Field>
        <Field label="Jedinica mere"><input value={form.unit} onChange={(e) => set("unit", e.target.value)} /></Field>
        <Field label="PDV %"><input type="number" step="0.01" value={form.vat_rate} onChange={(e) => set("vat_rate", e.target.value)} /></Field>
      </div>
      <FormActions onSave={save} onCancel={editId ? resetForm : undefined} saveLabel={editId ? "Izmeni" : "Dodaj"} />
      <ErrorMessage message={error} /><SuccessMessage message={success} />
      <table className="data-table">
        <thead><tr><th>Šifra</th><th>Naziv</th><th>Cena</th><th>JM</th><th>PDV</th><th></th></tr></thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.id}>
              <td>{item.code}</td><td>{item.name}</td><td>{item.price}</td><td>{item.unit}</td><td>{item.vat_rate}%</td>
              <td className="actions"><button type="button" onClick={() => startEdit(item)}>Izmeni</button></td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
