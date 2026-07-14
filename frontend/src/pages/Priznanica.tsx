import { useEffect, useState } from "react";
import { api, type Producer } from "../api";
import { ErrorMessage, Field, FormActions } from "../components/Form";

const today = new Date().toISOString().slice(0, 10);
const monthStart = today.slice(0, 8) + "01";

export function PriznanicaPage() {
  const [producers, setProducers] = useState<Producer[]>([]);
  const [producerCode, setProducerCode] = useState("");
  const [dateFrom, setDateFrom] = useState(monthStart);
  const [dateTo, setDateTo] = useState(today);
  const [documentNo, setDocumentNo] = useState(1);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    api.listProducers().then((p) => {
      setProducers(p);
      if (p.length) setProducerCode(p[0].code);
    });
  }, []);

  function download() {
    setError(null);
    if (!producerCode) { setError("Izaberite proizvođača."); return; }
    window.open(api.priznanicaPdfUrl({
      producer_code: producerCode,
      date_from: dateFrom,
      date_to: dateTo,
      document_no: documentNo,
    }), "_blank");
  }

  return (
    <div className="panel">
      <h2>Priznanica (PDF)</h2>
      <p className="subtitle">
        Generiše priznanicu za proizvođača — isti dokument koji je stari Clipper štampao na kraju otkupa.
      </p>
      <div className="form-grid">
        <Field label="Proizvođač *">
          <select value={producerCode} onChange={(e) => setProducerCode(e.target.value)}>
            {producers.map((p) => <option key={p.id} value={p.code}>{p.name} ({p.code})</option>)}
          </select>
        </Field>
        <Field label="Od datuma"><input type="date" value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} /></Field>
        <Field label="Do datuma"><input type="date" value={dateTo} onChange={(e) => setDateTo(e.target.value)} /></Field>
        <Field label="Broj priznanice"><input type="number" min={1} value={documentNo} onChange={(e) => setDocumentNo(Number(e.target.value))} /></Field>
      </div>
      <FormActions onSave={download} saveLabel="Preuzmi PDF" />
      <ErrorMessage message={error} />
    </div>
  );
}
