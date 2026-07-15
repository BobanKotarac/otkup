# Otkup — Modern Fruit Purchase System

Modern replacement for the legacy Clipper **OTKUP MALINE** application, built with **React** and **Python (FastAPI)**.

Includes **DBF import** for existing clients migrating from the old Clipper system.

**Repository:** https://github.com/BobanKotarac/otkup

---

## Requirements

Install these once on the machine:

| Tool | Mac | Windows |
|------|-----|---------|
| **Python 3.11+** | [python.org](https://www.python.org/downloads/) or `brew install python` | [python.org](https://www.python.org/downloads/) — check **"Add Python to PATH"**. Run with `py -3` if `python` is not found |
| **Node.js 22+ (LTS)** | [nodejs.org](https://nodejs.org) or `brew install node` | [nodejs.org](https://nodejs.org) — **only needed to rebuild the UI**. Normal use on Windows needs **Python only** if `frontend/dist` is included |
| **Git** | `brew install git` | [git-scm.com](https://git-scm.com/download/win) |

---

## Quick start (single machine — recommended)

One command builds the UI and starts the server on **http://localhost:8000**.

### Mac / Linux

If you already have the project:

```bash
cd otkup
chmod +x scripts/start.sh   # only needed once
./scripts/start.sh
```

First time (clone from GitHub):

```bash
git clone https://github.com/BobanKotarac/otkup.git
cd otkup
chmod +x scripts/start.sh
./scripts/start.sh
```

When it works, the terminal shows:
```
Starting Otkup on http://localhost:8000
INFO:     Uvicorn running on http://0.0.0.0:8000
```

Open **http://localhost:8000** in Chrome or Edge.

**Stop the server:** `Ctrl+C` in the terminal.

**Port 8000 busy?** Use another port:
```bash
PORT=8001 ./scripts/start.sh
```
Then open **http://localhost:8001**.

### Windows

```cmd
git clone https://github.com/BobanKotarac/otkup.git
cd otkup
scripts\start.bat
```

Or double-click **`START-OTKUP.bat`** in the project folder (easier — window stays open if something fails).

Open **http://localhost:8000** in Chrome or Edge.

**Requirements on Windows:** **Python 3** only (`py -3`). AppData install is fine — the script does not use a virtual environment.

**If `npm install` fails:** pull the latest version — the repo includes a pre-built UI in `frontend/dist`, so npm is skipped automatically.

The first run installs dependencies and may take a few minutes. Later runs are faster.

**Data is stored in:** `backend/otkup.db` (SQLite, single-machine use)

---

## First-time setup in the app

### New client (no old data)

1. Open http://localhost:8000
2. Click the blue banner **Pokreni čarobnjak**, or go to **Ostalo → Početno podešavanje**
3. Complete: Firma → Otkupna mesta → Voće → Roba → Proizvođači
4. Start entering purchases under **Unos → Otkup voća**

### Existing client (has Clipper DBF files)

1. Open the app → **Ostalo → Import DBF**
2. Upload a `.zip` with all `.dbf` files, or upload files individually
3. Check **"Obriši postojeće podatke pre importa"** on first import

Typical DBF files: `COMPANY.DBF`, `MESTA.DBF`, `VOCE.DBF`, `ROBA.DBF`, `KOM.DBF`, `OTKUP.DBF`, `ZADUZ.DBF`, `AMB.DBF`

---

## Development mode (two terminals)

Use this if you are actively editing code.

### Mac

**Terminal 1 — backend:**
```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

**Terminal 2 — frontend:**
```bash
cd frontend
npm install
npm run dev
```

Open http://localhost:5173

### Windows

**Terminal 1 — backend:**
```cmd
cd backend
py -3 -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```
(Use `python` instead of `py -3` if `python` works on your PC.)

**Terminal 2 — frontend:**
```cmd
cd frontend
npm install
npm run dev
```

Open http://localhost:5173

---

## Main features

| Feature | Menu location |
|---------|---------------|
| Purchase entry (with legacy validations) | Unos → Otkup voća |
| Goods debits | Unos → Unos zaduženja |
| Master data (locations, producers, fruit, goods) | Unos |
| Live dashboard | Ostalo → Live pregled |
| Setup wizard | Ostalo → Početno podešavanje |
| PDF Priznanica + direct print | Izveštaji → Priznanica |
| DBF import | Ostalo → Import DBF |
| Global search | Search bar (top right) |

---

## Project structure

```
otkup/
├── otkup/              # Original Clipper source (reference)
├── backend/            # FastAPI + SQLAlchemy API
├── frontend/           # React + TypeScript UI
├── scripts/
│   ├── start.sh        # Mac/Linux single-machine start
│   └── start.bat       # Windows single-machine start
├── docker-compose.yml  # PostgreSQL (optional, multi-user)
└── README.md
```

---

## Optional: PostgreSQL (multi-user / production)

For multiple users at once, use PostgreSQL instead of SQLite:

```bash
docker compose up -d
```

Create `backend/.env`:
```
DATABASE_URL=postgresql://otkup:otkup@localhost:5432/otkup
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `npm install` fails (Windows) | Use latest code with pre-built `frontend/dist` — only Python needed |
| Python venv / subprocess error (Windows) | Latest `start.bat` skips venv — AppData Python is OK. Run `git pull`, delete `backend\.venv` if it exists, try again |
| `start.bat` window closes immediately (Windows) | Double-click **`START-OTKUP.bat`** — errors stay on screen. Check **`otkup-start.log`** |
| `env: bash\r: No such file or directory` (Mac) | Run `perl -pi -e 's/\r\n/\n/g' scripts/start.sh` then try again |
| `python` not found (Windows) | Use `py -3` instead — `start.bat` tries this automatically. Or reinstall Python with **Add to PATH** checked |
| `npm` not found | Install Node.js LTS and restart terminal |
| Port 8000 already in use | Another app is using that port. Stop it: `lsof -ti :8000 \| xargs kill` — or run `PORT=8001 ./scripts/start.sh` |
| Wrong app opens on localhost:8000 | Port 8000 is taken by a different project — use `PORT=8001 ./scripts/start.sh` |
| Blank page after start | Wait for build to finish; check terminal for errors |
| Backend not reachable (dev mode) | Ensure backend runs on port 8000 |

### Manual start (if the script fails)

**Terminal 1 — backend:**
```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

**Terminal 2 — frontend (dev UI):**
```bash
cd frontend
npm install
npm run dev
```

Open **http://localhost:5173** (dev) or **http://localhost:8000** (after `npm run build` in frontend).

---

## Legacy reference

Original Clipper menus are preserved in the React navigation. Business logic in `otkup/extra.prg` is the reference for further development.
