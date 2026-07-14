import { useEffect, useState } from "react";
import {
  fetchSupportedTables,
  importDbf,
  type ImportReport,
  type SupportedTable,
} from "../api";

export function DbfImport() {
  const [tables, setTables] = useState<SupportedTable[]>([]);
  const [file, setFile] = useState<File | null>(null);
  const [clearExisting, setClearExisting] = useState(false);
  const [loading, setLoading] = useState(false);
  const [report, setReport] = useState<ImportReport | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchSupportedTables()
      .then(setTables)
      .catch((e: Error) => setError(e.message));
  }, []);

  async function handleImport() {
    if (!file) return;
    setLoading(true);
    setError(null);
    setReport(null);
    try {
      const result = await importDbf(file, clearExisting);
      setReport(result);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Import failed");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="panel">
      <h2>Import DBF fajlova</h2>
      <p className="subtitle">
        Uvezite podatke iz starog Clipper sistema. Pošaljite pojedinačni <code>.dbf</code>{" "}
        fajl ili <code>.zip</code> arhivu sa svim DBF fajlovima klijenta.
      </p>

      <section className="import-section">
        <h3>Podržani fajlovi</h3>
        <table className="data-table">
          <thead>
            <tr>
              <th>DBF fajl</th>
              <th>Tabela</th>
              <th>Opis</th>
            </tr>
          </thead>
          <tbody>
            {tables.map((t) => (
              <tr key={t.dbf_file}>
                <td><code>{t.dbf_file.toUpperCase()}.DBF</code></td>
                <td>{t.model}</td>
                <td>{t.description}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>

      <section className="import-section">
        <h3>Učitaj podatke</h3>
        <div className="form-row">
          <input
            type="file"
            accept=".dbf,.zip"
            onChange={(e) => setFile(e.target.files?.[0] ?? null)}
          />
        </div>
        <label className="checkbox-row">
          <input
            type="checkbox"
            checked={clearExisting}
            onChange={(e) => setClearExisting(e.target.checked)}
          />
          Obriši postojeće podatke pre importa (preporučeno pri prvom uvozu klijenta)
        </label>
        <button
          type="button"
          className="btn-primary"
          disabled={!file || loading}
          onClick={handleImport}
        >
          {loading ? "Import u toku..." : "Pokreni import"}
        </button>
      </section>

      {error && <p className="error">{error}</p>}

      {report && (
        <section className="import-section">
          <h3>Rezultat importa</h3>
          <p>
            Ukupno uvezeno: <strong>{report.total_imported}</strong> zapisa
            {report.files_unrecognized.length > 0 && (
              <> · Neprepoznati fajlovi: {report.files_unrecognized.join(", ")}</>
            )}
          </p>
          <table className="data-table">
            <thead>
              <tr>
                <th>Fajl</th>
                <th>Tabela</th>
                <th>Uvezeno</th>
                <th>Preskočeno</th>
                <th>Greške</th>
              </tr>
            </thead>
            <tbody>
              {report.results.map((r) => (
                <tr key={`${r.table}-${r.filename}`} className={r.errors.length ? "row-error" : ""}>
                  <td>{r.filename}</td>
                  <td>{r.table}</td>
                  <td>{r.imported}</td>
                  <td>{r.skipped}</td>
                  <td>{r.errors.length ? r.errors.join("; ") : "—"}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      )}
    </div>
  );
}
