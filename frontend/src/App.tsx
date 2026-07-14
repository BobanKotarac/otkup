import { useState, type ComponentType } from "react";
import { SearchBar } from "./components/SearchBar";
import { Dashboard } from "./pages/Dashboard";
import { DbfImport } from "./pages/DbfImport";
import { CompanyPage } from "./pages/Company";
import { PurchaseLocationsPage } from "./pages/PurchaseLocations";
import { ProducersPage } from "./pages/Producers";
import { FruitsPage } from "./pages/Fruits";
import { GoodsPage } from "./pages/Goods";
import { FruitPurchasePage } from "./pages/FruitPurchase";
import { GoodsDebitPage } from "./pages/GoodsDebit";
import { PackagingPage } from "./pages/Packaging";
import { PriznanicaPage } from "./pages/Priznanica";
import { SetupWizard, SetupBanner } from "./pages/SetupWizard";
import {
  ReportBalancePage,
  ReportDebitsPage,
  ReportPackagingPage,
  ReportPurchasesPage,
} from "./pages/Reports";
import "./App.css";

type MainMenu = "unos" | "izvestaji" | "ambalaza" | "ostalo";

type View =
  | "dashboard"
  | "setup-wizard"
  | "dbf-import"
  | "company"
  | "purchase-locations"
  | "producers"
  | "fruits"
  | "goods"
  | "fruit-purchase"
  | "goods-debit"
  | "packaging"
  | "priznanica"
  | "report-purchases"
  | "report-debits"
  | "report-balance"
  | "report-packaging";

const MAIN_MENUS: { id: MainMenu; label: string }[] = [
  { id: "unos", label: "Unos" },
  { id: "izvestaji", label: "Izveštaji" },
  { id: "ambalaza", label: "Ambalaža" },
  { id: "ostalo", label: "Ostalo" },
];

const SUB_MENUS: Record<MainMenu, { id: View; label: string; message: string }[]> = {
  unos: [
    { id: "fruit-purchase", label: "Otkup voća", message: "Unos i ispravka otkupa voća" },
    { id: "goods-debit", label: "Unos zaduženja", message: "Unos zaduženja robom" },
    { id: "goods", label: "Roba", message: "Šifarnik robe" },
    { id: "fruits", label: "Voće", message: "Šifarnik voća" },
    { id: "producers", label: "Proizvođači", message: "Šifarnik proizvođača" },
    { id: "purchase-locations", label: "Otkupna mesta", message: "Šifarnik otkupnih mesta" },
  ],
  izvestaji: [
    { id: "report-purchases", label: "Pregled otkupa", message: "Pregled otkupa voća" },
    { id: "report-debits", label: "Pregled zaduženja", message: "Pregled zaduženja robom" },
    { id: "report-balance", label: "Pregled salda", message: "Saldo otkupa i zaduženja" },
    { id: "priznanica", label: "Priznanica (PDF)", message: "Štampa priznanice za proizvođača" },
  ],
  ambalaza: [
    { id: "packaging", label: "Ambalaža", message: "Unos ambalaže" },
    { id: "report-packaging", label: "Izveštaj o ambalaži", message: "Pregled ambalaže" },
  ],
  ostalo: [
    { id: "dashboard", label: "Live pregled", message: "Pregled poslovanja u realnom vremenu" },
    { id: "setup-wizard", label: "Početno podešavanje", message: "Čarobnjak za nove klijente" },
    { id: "company", label: "Podaci o firmi", message: "Podešavanje firme" },
    { id: "dbf-import", label: "Import DBF", message: "Uvoz podataka iz starog Clipper sistema" },
  ],
};

const VIEW_COMPONENTS: Record<View, ComponentType<{ onComplete?: () => void }>> = {
  "dashboard": Dashboard,
  "setup-wizard": SetupWizard,
  "dbf-import": DbfImport,
  "company": CompanyPage,
  "purchase-locations": PurchaseLocationsPage,
  "producers": ProducersPage,
  "fruits": FruitsPage,
  "goods": GoodsPage,
  "fruit-purchase": FruitPurchasePage,
  "goods-debit": GoodsDebitPage,
  "packaging": PackagingPage,
  "priznanica": PriznanicaPage,
  "report-purchases": ReportPurchasesPage,
  "report-debits": ReportDebitsPage,
  "report-balance": ReportBalancePage,
  "report-packaging": ReportPackagingPage,
};

const SEARCH_NAV: Record<string, { menu: MainMenu; view: View }> = {
  producer: { menu: "unos", view: "producers" },
  location: { menu: "unos", view: "purchase-locations" },
  fruit: { menu: "unos", view: "fruits" },
  good: { menu: "unos", view: "goods" },
};

function App() {
  const [mainMenu, setMainMenu] = useState<MainMenu>("ostalo");
  const [view, setView] = useState<View>("dashboard");
  const [message, setMessage] = useState("Pregled poslovanja u realnom vremenu");
  const [setupRefresh, setSetupRefresh] = useState(0);

  function navigateTo(menu: MainMenu, v: View, msg?: string) {
    setMainMenu(menu);
    setView(v);
    const item = SUB_MENUS[menu].find((s) => s.id === v);
    if (msg) setMessage(msg);
    else if (item) setMessage(item.message);
  }

  function selectSub(item: (typeof SUB_MENUS)[MainMenu][number]) {
    navigateTo(mainMenu, item.id, item.message);
  }

  function onMainMenuChange(menu: MainMenu) {
    const first = SUB_MENUS[menu][0];
    navigateTo(menu, first.id, first.message);
  }

  function onSearchNavigate(type: string, _code: string) {
    const nav = SEARCH_NAV[type];
    if (nav) navigateTo(nav.menu, nav.view);
  }

  const Page = VIEW_COMPONENTS[view];
  const onSetupComplete = () => setSetupRefresh((k) => k + 1);

  return (
    <div className="app">
      <header className="header">
        <div className="header-row">
          <div>
            <h1>OTKUP MALINE</h1>
            <p>Sistem za otkup voća</p>
          </div>
          <SearchBar onNavigate={onSearchNavigate} />
        </div>
      </header>

      <SetupBanner
        refreshKey={setupRefresh}
        onStart={() => navigateTo("ostalo", "setup-wizard")}
      />

      <nav className="main-nav">
        {MAIN_MENUS.map((m) => (
          <button
            key={m.id}
            type="button"
            className={mainMenu === m.id ? "active" : ""}
            onClick={() => onMainMenuChange(m.id)}
          >
            {m.label}
          </button>
        ))}
      </nav>

      <div className="layout">
        <aside className="sub-nav">
          {SUB_MENUS[mainMenu].map((item) => (
            <button
              key={item.id + item.label}
              type="button"
              className={view === item.id ? "active" : ""}
              onClick={() => selectSub(item)}
            >
              {item.label}
            </button>
          ))}
        </aside>

        <main className="content">
          <p className="breadcrumb">{message}</p>
          <Page onComplete={view === "setup-wizard" ? onSetupComplete : undefined} />
        </main>
      </div>
    </div>
  );
}

export default App;
