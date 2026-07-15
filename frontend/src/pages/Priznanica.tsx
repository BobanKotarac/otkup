import { useEffect, useState } from "react";
import { api, type Producer } from "../api";
import { ErrorMessage, Field, FormActions, SuccessMessage } from "../components/Form";
import { printPdfInBrowser } from "../utils/print";

const today = new Date().toISOString().slice(0, 10);
const monthStart = today.slice(0, 8) + "01";

type PriznanicaParams = {
  producer_code: string;
  date_from: string;
  date_to: string;
  document_no: number;
};

export function PriznanicaPage() {
  const [producers, setProducers] = useState<Producer[]>([]);
  const [producerCode, setProducerCode] = useState("");
  const [dateFrom, setDateFrom] = useState(monthStart);
  const [dateTo, setDateTo] = useState(today);
  const [documentNo, setDocumentNo] = useState(1);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [printing, setPrinting] = useState(false);

  useEffect(() => {
    api.listProducers().then((p) => {
      setProducers(p);
      if (p.length) setProducerCode(p[0].code);
    });
  }, []);

  function params(): PriznanicaParams | null {
    if (!producerCode) return null;
    return {
      producer_code: producerCode,
      date_from: dateFrom,
      date_to: dateTo,
      document_no: documentNo,
    };
  }

  function download() {
    setError(null);
    setSuccess(null);
    const p = params();
    if (!p) {
      setError("Izaberite proizvođača.");
      return;
    }
    window.open(api.priznanicaPdfUrl(p), "_blank");
  }

  async function printDoc() {
    setError(null);
    setSuccess(null);
    const p = params();
    if (!p) {
      setError("Izaberite proizvođača.");
      return;
    }

    setPrinting(true);
    try {
      const result = await api.printPriznanica(p);
      setSuccess(result.message);
    } catch (err) {
      try {
        await printPdfInBrowser(api.priznanicaPdfUrl(p));
        setSuccess("Otvoren dijalog za štampu u pregledaču.");
      } catch {
        setError(err instanceof Error ? err.message : "Štampanje nije uspelo.");
      }
    } finally {
      setPrinting(false);
    }
  }

  return (
    <div className="panel">
      <h2>Priznanica</h2>
      <p className="subtitle">
        Štampa priznanicu za proizvođača na podrazumevani štampač ovog računara (isti dokument kao stari Clipper).
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
      <FormActions
        onSave={printDoc}
        saveLabel="Štampaj"
        saving={printing}
        onSecondary={download}
        secondaryLabel="Preuzmi PDF"
      />
      <SuccessMessage message={success} />
      <ErrorMessage message={error} />
    </div>
  );
}
