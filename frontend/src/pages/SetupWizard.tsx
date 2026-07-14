import { useEffect, useState } from "react";
import { api, type SetupStatus } from "../api";
import { CompanyPage } from "./Company";
import { PurchaseLocationsPage } from "./PurchaseLocations";
import { FruitsPage } from "./Fruits";
import { GoodsPage } from "./Goods";
import { ProducersPage } from "./Producers";
import { ErrorMessage, SuccessMessage } from "../components/Form";

const STEPS = [
  { key: "company", title: "Podaci o firmi", component: CompanyPage },
  { key: "locations", title: "Otkupna mesta", component: PurchaseLocationsPage },
  { key: "fruits", title: "Voće", component: FruitsPage },
  { key: "goods", title: "Roba", component: GoodsPage },
  { key: "producers", title: "Proizvođači", component: ProducersPage },
] as const;

interface SetupWizardProps {
  onComplete?: () => void;
}

export function SetupWizard({ onComplete }: SetupWizardProps) {
  const [status, setStatus] = useState<SetupStatus | null>(null);
  const [step, setStep] = useState(0);
  const [done, setDone] = useState(false);

  function refresh() {
    api.setupStatus().then((s) => {
      setStatus(s);
      if (s.complete) {
        setDone(true);
        onComplete?.();
      } else {
        const idx = STEPS.findIndex((st) => st.key === s.next_step);
        if (idx >= 0) setStep(idx);
      }
    });
  }

  useEffect(() => { refresh(); }, []);

  if (!status) return <div className="panel"><p>Učitavanje...</p></div>;

  if (done || status.complete) {
    return (
      <div className="panel wizard-done">
        <h2>Setup završen!</h2>
        <SuccessMessage message="Svi osnovni šifarnici su podešeni. Čarobnjak više neće biti ponuđen automatski." />
        <p className="hint">Možete ga ponovo otvoriti iz menija <strong>Ostalo → Početno podešavanje</strong> ako zatreba.</p>
      </div>
    );
  }

  const Current = STEPS[step].component;

  return (
    <div className="panel">
      <h2>Početno podešavanje</h2>
      <p className="subtitle">Korak {step + 1} od {STEPS.length}: {STEPS[step].title}</p>
      <div className="wizard-steps">
        {STEPS.map((s, i) => (
          <span key={s.key} className={`wizard-step ${i === step ? "active" : ""} ${i < step ? "done" : ""}`}>
            {i + 1}. {s.title}
          </span>
        ))}
      </div>
      <Current />
      <div className="form-actions">
        {step > 0 && (
          <button type="button" className="btn-secondary" onClick={() => setStep(step - 1)}>Nazad</button>
        )}
        <button type="button" className="btn-primary" onClick={() => { refresh(); setStep(Math.min(step + 1, STEPS.length - 1)); }}>
          {step < STEPS.length - 1 ? "Sledeći korak" : "Završi setup"}
        </button>
      </div>
      <ErrorMessage message={null} />
    </div>
  );
}

export function SetupBanner({ onStart, refreshKey = 0 }: { onStart: () => void; refreshKey?: number }) {
  const [status, setStatus] = useState<SetupStatus | null>(null);

  useEffect(() => {
    api.setupStatus().then(setStatus);
  }, [refreshKey]);

  // Re-check while incomplete (user may finish via regular menus, not the wizard)
  useEffect(() => {
    if (status?.complete) return;
    const interval = setInterval(() => {
      api.setupStatus().then(setStatus);
    }, 5000);
    return () => clearInterval(interval);
  }, [status?.complete]);

  if (!status || status.complete) return null;
  return (
    <div className="setup-banner">
      <span>Novi klijent? Završite <strong>početno podešavanje</strong> ({status.next_step})</span>
      <button type="button" className="btn-primary" onClick={onStart}>Pokreni čarobnjak</button>
    </div>
  );
}
