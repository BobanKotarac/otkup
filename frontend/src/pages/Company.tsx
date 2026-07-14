import { useEffect, useState } from "react";
import { api, type Company } from "../api";
import { ErrorMessage, Field, FormActions, SuccessMessage } from "../components/Form";

const empty: Omit<Company, "id"> = {
  name: "", address: "", city: "", phone: "",
  bank_account: "", tax_id: "", registration_number: "", activity_code: "",
};

export function CompanyPage() {
  const [form, setForm] = useState(empty);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  useEffect(() => {
    api.getCompany().then((c) => { if (c) setForm(c); });
  }, []);

  function set(key: keyof typeof empty, value: string) {
    setForm((f) => ({ ...f, [key]: value }));
  }

  async function save() {
    setError(null); setSuccess(null);
    try {
      await api.saveCompany(form);
      setSuccess("Podaci o firmi sačuvani.");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Greška");
    }
  }

  return (
    <div className="panel">
      <h2>Podaci o firmi</h2>
      <div className="form-grid">
        <Field label="Naziv"><input value={form.name} onChange={(e) => set("name", e.target.value)} /></Field>
        <Field label="Adresa"><input value={form.address} onChange={(e) => set("address", e.target.value)} /></Field>
        <Field label="Mesto"><input value={form.city} onChange={(e) => set("city", e.target.value)} /></Field>
        <Field label="Telefon"><input value={form.phone} onChange={(e) => set("phone", e.target.value)} /></Field>
        <Field label="Žiro račun"><input value={form.bank_account} onChange={(e) => set("bank_account", e.target.value)} /></Field>
        <Field label="PIB"><input value={form.tax_id} onChange={(e) => set("tax_id", e.target.value)} /></Field>
        <Field label="Matični broj"><input value={form.registration_number} onChange={(e) => set("registration_number", e.target.value)} /></Field>
        <Field label="Šifra delatnosti"><input value={form.activity_code} onChange={(e) => set("activity_code", e.target.value)} /></Field>
      </div>
      <FormActions onSave={save} />
      <ErrorMessage message={error} /><SuccessMessage message={success} />
    </div>
  );
}
