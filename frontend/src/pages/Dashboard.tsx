import { useCallback, useEffect, useState } from "react";
import { api, type LiveDashboard } from "../api";

export function Dashboard() {
  const [data, setData] = useState<LiveDashboard | null>(null);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(() => {
    api.liveDashboard()
      .then(setData)
      .catch((e: Error) => setError(e.message));
  }, []);

  useEffect(() => {
    load();
    const interval = setInterval(load, 30000);
    return () => clearInterval(interval);
  }, [load]);

  if (error) {
    return (
      <div className="panel">
        <h2>Live pregled</h2>
        <p className="error">Backend nije dostupan: {error}</p>
      </div>
    );
  }

  if (!data) return <div className="panel"><p>Učitavanje...</p></div>;

  const empty = data.totals.producers === 0 && data.totals.fruits === 0;

  return (
    <div className="panel">
      <div className="dashboard-header">
        <h2>Live pregled — {data.date}</h2>
        <button type="button" className="btn-secondary" onClick={load}>Osveži</button>
      </div>

      {empty && (
        <div className="notice">
          Počnite od <strong>Početno podešavanje</strong> ili <strong>Unos → Otkupna mesta</strong>.
        </div>
      )}

      <div className="live-stats">
        <div className="live-stat highlight">
          <span className="stat-value">{data.today_kg.toFixed(0)}</span>
          <span className="stat-label">kg danas</span>
        </div>
        <div className="live-stat highlight">
          <span className="stat-value">{data.today_value.toLocaleString("sr-RS", { maximumFractionDigits: 0 })}</span>
          <span className="stat-label">RSD danas</span>
        </div>
        <div className="live-stat">
          <span className="stat-value">{data.today_purchases}</span>
          <span className="stat-label">otkupa danas</span>
        </div>
        <div className="live-stat">
          <span className="stat-value">{data.today_active_producers}</span>
          <span className="stat-label">proizvođača danas</span>
        </div>
        <div className="live-stat">
          <span className="stat-value">{data.packaging_returned_today - data.packaging_taken_today}</span>
          <span className="stat-label">ambalaža (neto)</span>
        </div>
      </div>

      <div className="dashboard-grid">
        <section>
          <h3>Po otkupnom mestu (danas)</h3>
          {data.by_location.length === 0 ? <p className="hint">Nema otkupa danas.</p> : (
            <table className="data-table">
              <thead><tr><th>Mesto</th><th>Kg</th><th>Vrednost</th><th>Otkupa</th></tr></thead>
              <tbody>
                {data.by_location.map((l) => (
                  <tr key={l.code}>
                    <td>{l.name}</td><td>{l.kg.toFixed(1)}</td><td>{l.value.toFixed(0)}</td><td>{l.count}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </section>

        <section>
          <h3>Top proizvođači (danas)</h3>
          {data.top_producers.length === 0 ? <p className="hint">Nema otkupa danas.</p> : (
            <table className="data-table">
              <thead><tr><th>Proizvođač</th><th>Kg</th><th>Vrednost</th></tr></thead>
              <tbody>
                {data.top_producers.map((p) => (
                  <tr key={p.code}>
                    <td>{p.name}</td><td>{p.kg.toFixed(1)}</td><td>{p.value.toFixed(0)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </section>
      </div>

      <h3>Ukupno u sistemu</h3>
      <div className="stats-grid">
        {[
          { label: "Otkupna mesta", value: data.totals.purchase_locations },
          { label: "Proizvođači", value: data.totals.producers },
          { label: "Voće", value: data.totals.fruits },
          { label: "Roba", value: data.totals.goods },
          { label: "Otkupi", value: data.totals.fruit_purchases },
          { label: "Zaduženja", value: data.totals.goods_debits },
        ].map((c) => (
          <div key={c.label} className="stat-card">
            <span className="stat-value">{c.value}</span>
            <span className="stat-label">{c.label}</span>
          </div>
        ))}
      </div>
    </div>
  );
}
