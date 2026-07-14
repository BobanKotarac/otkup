import { type ReactNode } from "react";

interface FieldProps {
  label: string;
  children: ReactNode;
}

export function Field({ label, children }: FieldProps) {
  return (
    <label className="field">
      <span>{label}</span>
      {children}
    </label>
  );
}

interface FormActionsProps {
  onSave: () => void;
  onCancel?: () => void;
  saving?: boolean;
  saveLabel?: string;
}

export function FormActions({ onSave, onCancel, saving, saveLabel = "Sačuvaj" }: FormActionsProps) {
  return (
    <div className="form-actions">
      <button type="button" className="btn-primary" onClick={onSave} disabled={saving}>
        {saving ? "Čuvanje..." : saveLabel}
      </button>
      {onCancel && (
        <button type="button" className="btn-secondary" onClick={onCancel}>
          Otkaži
        </button>
      )}
    </div>
  );
}

export function ErrorMessage({ message }: { message: string | null }) {
  if (!message) return null;
  return <p className="error">{message}</p>;
}

export function SuccessMessage({ message }: { message: string | null }) {
  if (!message) return null;
  return <p className="success">{message}</p>;
}
