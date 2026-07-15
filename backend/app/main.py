from pathlib import Path

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

from app.config import settings
from app.database import Base, engine
from app.routers import crud, features, system

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Otkup API",
    description="Modern fruit purchase management",
    version="0.2.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origin_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(system.router)
app.include_router(crud.router)
app.include_router(features.router)

# Serve built frontend from one port (single-machine / remote demo)
_FRONTEND_DIST = Path(__file__).resolve().parents[2] / "frontend" / "dist"
if _FRONTEND_DIST.is_dir():
    app.mount("/assets", StaticFiles(directory=_FRONTEND_DIST / "assets"), name="assets")

    @app.get("/{full_path:path}")
    async def serve_spa(full_path: str):
        if full_path.startswith("api/") or full_path == "api":
            raise HTTPException(status_code=404, detail="API route not found")
        index = _FRONTEND_DIST / "index.html"
        if full_path and (_FRONTEND_DIST / full_path).is_file():
            return FileResponse(_FRONTEND_DIST / full_path)
        return FileResponse(index)
