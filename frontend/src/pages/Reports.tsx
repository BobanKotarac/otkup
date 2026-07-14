import { useCallback, useEffect, useState } from "react";
import { api, type BalanceRow, type FruitPurchase, type GoodsDebit, type PackagingRecord, type PurchaseLocation } from "../api";
import { Field } from "../components/Form";

function useDateFilters() {
  const [dateFrom, setDateFrom] = useState("");
  const [dateTo, setDateTo] = useState("");
  const [locationCode, setLocationCode] = useState("");
  const [locations, setLocations] = useState<PurchaseLocation[]>([]);

  useEffect(() => { api.listLocations().then(setLocations); }, []);

  const params = () => {
    const p: Record<string, string> = {};
    if (dateFrom) p.date_from = dateFrom;
    if (dateTo) p.date_to = dateTo;
    if (locationCode) p.location_code = locationCode;
    return p;
  };

  return { dateFrom, setDateFrom, dateTo, setDateTo, locationCode, setLocationCode, locations, params };
}

function FilterBar({ filters, onRefresh }: { filters: ReturnType<typeof useDateFilters>; onRefresh: () => void }) {
  return (
    <div className="filter-row form-grid">
      <Field label="Od datuma"><input type="date" value={filters.dateFrom} onChange={(e) => filters.setDateFrom(e.target.value)} /></Field>
      <Field label="Do datuma"><input type="date" value={filters.dateTo} onChange={(e) => filters.setDateTo(e.target.value)} /></Field>
      <Field label="Otkupno mesto">
        <select value={filters.locationCode} onChange={(e) => filters.setLocationCode(e.target.value)}>
          <option value="">Sva mesta</option>
          {filters.locations.map((l) => <option key={l.id} value={l.code}>{l.name}</option>)}
        </select>
      </Field>
      <div className="form-actions"><button type="button" className="btn-primary" onClick={onRefresh}>Osveži</button></div>
    </div>
  );
}

export function ReportPurchasesPage() {
  const filters = useDateFilters();
  const [rows, setRows] = useState<FruitPurchase[]>([]);
  const load = useCallback(() => { api.listPurchases(filters.params()).then(setRows); }, [filters.dateFrom, filters.dateTo, filters.locationCode]);
  useEffect(() => { load(); }, [load]);
  const total = rows.reduce((s, r) => s + (r.total_value ?? 0), 0);
  return (
    <div className="panel">
      <h2>Pregled otkupa</h2>
      <FilterBar filters={filters} onRefresh={load} />
      <table className="data-table">
        <thead><tr><th>Datum</th><th>Proizvođač</th><th>Voće</th><th>Kg</th><th>Vrednost</th></tr></thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id}>
              <td>{r.purchase_date}</td><td>{r.producer_name}</td><td>{r.fruit_name}</td>
              <td>{(r.qty_extra + r.qty_class1 + r.qty_class2 + r.qty_class3).toFixed(2)}</td>
              <td>{r.total_value?.toFixed(2)}</td>
            </tr>
          ))}
        </tbody>
        <tfoot><tr><td colSpan={4}><strong>Ukupno</strong></td><td><strong>{total.toFixed(2)}</strong></td></tr></tfoot>
      </table>
    </div>
  );
}

export function ReportDebitsPage() {
  const filters = useDateFilters();
  const [rows, setRows] = useState<GoodsDebit[]>([]);
  const load = useCallback(() => { api.listDebits(filters.params()).then(setRows); }, [filters.dateFrom, filters.dateTo, filters.locationCode]);
  useEffect(() => { load(); }, [load]);
  const total = rows.reduce((s, r) => s + (r.total_value ?? 0), 0);
  return (
    <div className="panel">
      <h2>Pregled zaduženja</h2>
      <FilterBar filters={filters} onRefresh={load} />
      <table className="data-table">
        <thead><tr><th>Datum</th><th>Proizvođač</th><th>Roba</th><th>Kol.</th><th>Vrednost</th></tr></thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id}>
              <td>{r.debit_date}</td><td>{r.producer_name}</td><td>{r.good_name}</td>
              <td>{r.quantity}</td><td>{r.total_value?.toFixed(2)}</td>
            </tr>
          ))}
        </tbody>
        <tfoot><tr><td colSpan={4}><strong>Ukupno</strong></td><td><strong>{total.toFixed(2)}</strong></td></tr></tfoot>
      </table>
    </div>
  );
}

export function ReportBalancePage() {
  const filters = useDateFilters();
  const [rows, setRows] = useState<BalanceRow[]>([]);
  const load = useCallback(() => { api.reportBalance(filters.params()).then(setRows); }, [filters.dateFrom, filters.dateTo, filters.locationCode]);
  useEffect(() => { load(); }, [load]);
  return (
    <div className="panel">
      <h2>Pregled salda</h2>
      <p className="subtitle">Saldo = vrednost otkupa − vrednost zaduženja po proizvođaču.</p>
      <FilterBar filters={filters} onRefresh={load} />
      <table className="data-table">
        <thead><tr><th>Proizvođač</th><th>Otkup</th><th>Zaduženje</th><th>Saldo</th></tr></thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.producer_code} className={r.balance < 0 ? "row-error" : ""}>
              <td>{r.producer_name}</td><td>{r.fruit_value.toFixed(2)}</td>
              <td>{r.goods_value.toFixed(2)}</td><td><strong>{r.balance.toFixed(2)}</strong></td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export function ReportPackagingPage() {
  const filters = useDateFilters();
  const [rows, setRows] = useState<PackagingRecord[]>([]);
  const load = useCallback(() => { api.listPackaging(filters.params()).then(setRows); }, [filters.dateFrom, filters.dateTo]);
  useEffect(() => { load(); }, [load]);
  return (
    <div className="panel">
      <h2>Izveštaj o ambalaži</h2>
      <FilterBar filters={filters} onRefresh={load} />
      <table className="data-table">
        <thead><tr><th>Datum</th><th>Proizvođač</th><th>Uzeta</th><th>Vraćena</th><th>Razlika</th></tr></thead>
        <tbody>
          {rows.map((r) => (
            <tr key={r.id}>
              <td>{r.transaction_date}</td><td>{r.producer_name}</td>
              <td>{r.taken}</td><td>{r.returned}</td><td>{r.taken - r.returned}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
