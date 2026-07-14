import { useCallback, useEffect, useState } from "react";
import { api, type Fruit } from "../api";
import { ErrorMessage, Field, FormActions, SuccessMessage } from "../components/Form";

export function FruitsPage() {
  const [items, setItems] = useState<Fruit[]>([]);
  const [form, setForm] = useState({ name: "", price_extra: 0, price_class1: 0, price_class2: 0, price_class3: 0, vat_rate: 0 });
  const [editId, setEditId] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const load = useCallback(() => {
    api.listFruits().then(setItems).catch((e: Error) => setError(e.message));
  }, []);

  useEffect(() => { load(); }, [load]);

  function set(key: string, value: string | number) {
    setForm((f) => ({ ...f, [key]: typeof f[key as keyof typeof f] === "number" ? Number(value) : value }));
  }

  function resetForm() {
    setForm({ name: "", price_extra: 0, price_class1: 0, price_class2: 0, price_class3: 0, vat_rate: 0 });
    setEditId(null);
  }

  async function save() {
    setError(null); setSuccess(null);
    try {
      if (editId) { await api.updateFruit(editId, form); setSuccess("Voće izmenjeno."); }
      else { await api.createFruit(form); setSuccess("Voće dodato."); }
      resetForm(); load();
    } catch (e) { setError(e instanceof Error ? e.message : "Greška"); }
  }

  function startEdit(item: Fruit) {
    setEditId(item.id);
    setForm({ name: item.name, price_extra: item.price_extra, price_class1: item.price_class1, price_class2: item.price_class2, price_class3: item.price_class3, vat_rate: item.vat_rate });
  }

  return (
    <div className="panel">
      <h2>Voće</h2>
      <p className="subtitle">Šifarnik voća sa cenama po klasama kvaliteta.</p>
      <div className="form-grid">
        <Field label="Naziv *"><input value={form.name} onChange={(e) => set("name", e.target.value)} /></Field>
        <Field label="Cena ekstra"><input type="number" step="0.01" value={form.price_extra} onChange={(e) => set("price_extra", e.target.value)} /></Field>
        <Field label="Cena I klasa"><input type="number" step="0.01" value={form.price_class1} onChange={(e) => set("price_class1", e.target.value)} /></Field>
        <Field label="Cena II klasa"><input type="number" step="0.01" value={form.price_class2} onChange={(e) => set("price_class2", e.target.value)} /></Field>
        <Field label="Cena III klasa"><input type="number" step="0.01" value={form.price_class3} onChange={(e) => set("price_class3", e.target.value)} /></Field>
        <Field label="PDV %"><input type="number" step="0.01" value={form.vat_rate} onChange={(e) => set("vat_rate", e.target.value)} /></Field>
      </div>
      <FormActions onSave={save} onCancel={editId ? resetForm : undefined} saveLabel={editId ? "Izmeni" : "Dodaj"} />
      <ErrorMessage message={error} /><SuccessMessage message={success} />
      <table className="data-table">
        <thead><tr><th>Šifra</th><th>Naziv</th><th>Ekstra</th><th>I</th><th>II</th><th>III</th><th></th></tr></thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.id}>
              <td>{item.code}</td><td>{item.name}</td>
              <td>{item.price_extra}</td><td>{item.price_class1}</td><td>{item.price_class2}</td><td>{item.price_class3}</td>
              <td className="actions"><button type="button" onClick={() => startEdit(item)}>Izmeni</button></td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
