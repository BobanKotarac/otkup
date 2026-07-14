import { useCallback, useEffect, useState } from "react";
import { api, type PurchaseLocation } from "../api";
import { ErrorMessage, Field, FormActions, SuccessMessage } from "../components/Form";

export function PurchaseLocationsPage() {
  const [items, setItems] = useState<PurchaseLocation[]>([]);
  const [name, setName] = useState("");
  const [buyerName, setBuyerName] = useState("");
  const [buyerPhone, setBuyerPhone] = useState("");
  const [editId, setEditId] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const load = useCallback(() => {
    api.listLocations().then(setItems).catch((e: Error) => setError(e.message));
  }, []);

  useEffect(() => { load(); }, [load]);

  function resetForm() {
    setName(""); setBuyerName(""); setBuyerPhone(""); setEditId(null);
  }

  async function save() {
    setError(null); setSuccess(null);
    try {
      if (editId) {
        await api.updateLocation(editId, { name, buyer_name: buyerName, buyer_phone: buyerPhone });
        setSuccess("Mesto izmenjeno.");
      } else {
        await api.createLocation({ name, buyer_name: buyerName, buyer_phone: buyerPhone });
        setSuccess("Mesto dodato.");
      }
      resetForm(); load();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Greška");
    }
  }

  function startEdit(item: PurchaseLocation) {
    setEditId(item.id);
    setName(item.name);
    setBuyerName(item.buyer_name);
    setBuyerPhone(item.buyer_phone);
  }

  async function remove(id: number) {
    if (!confirm("Sakriti ovo otkupno mesto?")) return;
    await api.deleteLocation(id);
    load();
  }

  return (
    <div className="panel">
      <h2>Otkupna mesta</h2>
      <p className="subtitle">Prvo dodajte otkupna mesta — bez njih ne možete unositi proizvođače.</p>

      <div className="form-grid">
        <Field label="Naziv mesta *"><input value={name} onChange={(e) => setName(e.target.value)} /></Field>
        <Field label="Otkupljivač"><input value={buyerName} onChange={(e) => setBuyerName(e.target.value)} /></Field>
        <Field label="Telefon"><input value={buyerPhone} onChange={(e) => setBuyerPhone(e.target.value)} /></Field>
      </div>
      <FormActions onSave={save} onCancel={editId ? resetForm : undefined} saveLabel={editId ? "Izmeni" : "Dodaj"} />
      <ErrorMessage message={error} />
      <SuccessMessage message={success} />

      <table className="data-table">
        <thead><tr><th>Šifra</th><th>Naziv</th><th>Otkupljivač</th><th>Telefon</th><th></th></tr></thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.id}>
              <td>{item.code}</td><td>{item.name}</td><td>{item.buyer_name}</td><td>{item.buyer_phone}</td>
              <td className="actions">
                <button type="button" onClick={() => startEdit(item)}>Izmeni</button>
                <button type="button" onClick={() => remove(item.id)}>Sakrij</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
