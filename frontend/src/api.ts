const API_BASE =
  import.meta.env.VITE_API_URL ??
  (import.meta.env.DEV ? "http://localhost:8000" : "");

async function request<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${API_BASE}${path}`, options);
  if (!res.ok) {
    const err = await res.json().catch(() => ({ detail: res.statusText }));
    throw new Error(typeof err.detail === "string" ? err.detail : JSON.stringify(err.detail));
  }
  if (res.status === 204) return undefined as T;
  return res.json();
}

export interface DashboardStats {
  purchase_locations: number;
  producers: number;
  fruits: number;
  goods: number;
  fruit_purchases: number;
  goods_debits: number;
  packaging_records: number;
}

export interface Company {
  id: number;
  name: string;
  address: string;
  city: string;
  phone: string;
  bank_account: string;
  tax_id: string;
  registration_number: string;
  activity_code: string;
}

export interface PurchaseLocation {
  id: number;
  code: string;
  name: string;
  buyer_name: string;
  buyer_phone: string;
}

export interface Producer {
  id: number;
  code: string;
  name: string;
  location_code: string;
  tax_statement?: string;
  contract?: string;
  parcel_area?: number;
  bank_account?: string;
  personal_id?: string;
  vat_registered?: string;
  category?: string;
}

export interface Fruit {
  id: number;
  code: string;
  name: string;
  price_extra: number;
  price_class1: number;
  price_class2: number;
  price_class3: number;
  vat_rate: number;
}

export interface Good {
  id: number;
  code: string;
  name: string;
  price: number;
  unit: string;
  vat_rate: number;
}

export interface FruitPurchase {
  id: number;
  producer_code: string;
  fruit_code: string;
  purchase_date: string;
  qty_extra: number;
  qty_class1: number;
  qty_class2: number;
  qty_class3: number;
  document_no: string;
  producer_name?: string;
  fruit_name?: string;
  total_value?: number;
}

export interface GoodsDebit {
  id: number;
  producer_code: string;
  good_code: string;
  debit_date: string;
  quantity: number;
  document_no: string;
  unit_price: number;
  producer_name?: string;
  good_name?: string;
  total_value?: number;
}

export interface PackagingRecord {
  id: number;
  producer_code: string;
  transaction_date: string;
  taken: number;
  returned: number;
  document_no: string;
  producer_name?: string;
}

export interface BalanceRow {
  producer_code: string;
  producer_name: string;
  fruit_value: number;
  goods_value: number;
  balance: number;
}

export interface ImportReport {
  success: boolean;
  total_imported: number;
  files_found: string[];
  files_unrecognized: string[];
  results: { table: string; filename: string; imported: number; skipped: number; errors: string[] }[];
}

export interface SupportedTable {
  dbf_file: string;
  model: string;
  description: string;
}

export interface ValidationMessage {
  code: string;
  level: "warning" | "info" | "error";
  message: string;
}

export interface FruitPurchaseResponse {
  purchase: FruitPurchase;
  warnings: ValidationMessage[];
}

export interface SetupStatus {
  company_configured: boolean;
  has_locations: boolean;
  has_fruits: boolean;
  has_goods: boolean;
  has_producers: boolean;
  complete: boolean;
  next_step: string;
}

export interface SearchResultItem {
  type: string;
  id: number;
  code: string;
  name: string;
  extra: string;
}

export interface LiveDashboard {
  date: string;
  today_kg: number;
  today_value: number;
  today_purchases: number;
  today_active_producers: number;
  by_location: { code: string; name: string; kg: number; value: number; count: number }[];
  top_producers: { code: string; name: string; kg: number; value: number }[];
  packaging_taken_today: number;
  packaging_returned_today: number;
  totals: DashboardStats;
}

export const api = {
  stats: () => request<DashboardStats>("/api/stats"),

  getCompany: () => request<Company | null>("/api/company"),
  saveCompany: (data: Partial<Company>) =>
    request<Company>("/api/company", { method: "PUT", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),

  listLocations: () => request<PurchaseLocation[]>("/api/purchase-locations"),
  createLocation: (data: { name: string; buyer_name?: string; buyer_phone?: string }) =>
    request<PurchaseLocation>("/api/purchase-locations", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),
  updateLocation: (id: number, data: Partial<PurchaseLocation>) =>
    request<PurchaseLocation>(`/api/purchase-locations/${id}`, { method: "PUT", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),
  deleteLocation: (id: number) => request<void>(`/api/purchase-locations/${id}`, { method: "DELETE" }),

  listProducers: (locationCode?: string) =>
    request<Producer[]>(`/api/producers${locationCode ? `?location_code=${locationCode}` : ""}`),
  createProducer: (data: Record<string, unknown>) =>
    request<Producer>("/api/producers", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),
  updateProducer: (id: number, data: Record<string, unknown>) =>
    request<Producer>(`/api/producers/${id}`, { method: "PUT", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),
  deleteProducer: (id: number) => request<void>(`/api/producers/${id}`, { method: "DELETE" }),

  listFruits: () => request<Fruit[]>("/api/fruits"),
  createFruit: (data: Record<string, unknown>) =>
    request<Fruit>("/api/fruits", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),
  updateFruit: (id: number, data: Record<string, unknown>) =>
    request<Fruit>(`/api/fruits/${id}`, { method: "PUT", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),
  deleteFruit: (id: number) => request<void>(`/api/fruits/${id}`, { method: "DELETE" }),

  listGoods: () => request<Good[]>("/api/goods"),
  createGood: (data: Record<string, unknown>) =>
    request<Good>("/api/goods", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),
  updateGood: (id: number, data: Record<string, unknown>) =>
    request<Good>(`/api/goods/${id}`, { method: "PUT", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),
  deleteGood: (id: number) => request<void>(`/api/goods/${id}`, { method: "DELETE" }),

  listPurchases: (params?: Record<string, string>) => {
    const q = params ? "?" + new URLSearchParams(params).toString() : "";
    return request<FruitPurchase[]>(`/api/fruit-purchases${q}`);
  },
  createPurchase: (data: Record<string, unknown>) =>
    request<FruitPurchaseResponse>("/api/fruit-purchases", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),

  validatePurchase: (data: Record<string, unknown>) =>
    request<ValidationMessage[]>("/api/fruit-purchases/validate", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),

  liveDashboard: () => request<LiveDashboard>("/api/dashboard/live"),

  setupStatus: () => request<SetupStatus>("/api/setup/status"),

  search: (q: string) => request<{ query: string; results: SearchResultItem[] }>(`/api/search?q=${encodeURIComponent(q)}`),

  priznanicaPdfUrl: (params: { producer_code: string; date_from: string; date_to: string; document_no: number }) => {
    const q = new URLSearchParams({
      producer_code: params.producer_code,
      date_from: params.date_from,
      date_to: params.date_to,
      document_no: String(params.document_no),
    });
    return `${API_BASE}/api/reports/priznanica/pdf?${q}`;
  },

  listDebits: (params?: Record<string, string>) => {
    const q = params ? "?" + new URLSearchParams(params).toString() : "";
    return request<GoodsDebit[]>(`/api/goods-debits${q}`);
  },
  createDebit: (data: Record<string, unknown>) =>
    request<GoodsDebit>("/api/goods-debits", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),

  listPackaging: (params?: Record<string, string>) => {
    const q = params ? "?" + new URLSearchParams(params).toString() : "";
    return request<PackagingRecord[]>(`/api/packaging${q}`);
  },
  createPackaging: (data: Record<string, unknown>) =>
    request<PackagingRecord>("/api/packaging", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(data) }),

  reportBalance: (params?: Record<string, string>) => {
    const q = params ? "?" + new URLSearchParams(params).toString() : "";
    return request<BalanceRow[]>(`/api/reports/balance${q}`);
  },

  fetchSupportedTables: () => request<{ tables: SupportedTable[] }>("/api/import/supported-tables").then((r) => r.tables),

  importDbf: async (file: File, clearExisting: boolean): Promise<ImportReport> => {
    const form = new FormData();
    form.append("file", file);
    form.append("clear_existing", String(clearExisting));
    const res = await fetch(`${API_BASE}/api/import/dbf`, { method: "POST", body: form });
    if (!res.ok) {
      const err = await res.json().catch(() => ({ detail: res.statusText }));
      throw new Error(err.detail ?? "Import failed");
    }
    return res.json();
  },
};

// Legacy exports for existing pages
export const fetchStats = api.stats;
export const fetchSupportedTables = api.fetchSupportedTables;
export const importDbf = api.importDbf;
