"""Send a PDF to the system default printer (single-machine deployment)."""

from __future__ import annotations

import os
import subprocess
import sys
import tempfile
import threading


class PrintError(RuntimeError):
    pass


def _safe_unlink(path: str) -> None:
    try:
        os.unlink(path)
    except OSError:
        pass


def _print_windows(path: str) -> None:
    try:
        os.startfile(path, "print")  # noqa: S606 — Windows shell print verb
    except OSError:
        subprocess.run(
            [
                "powershell",
                "-NoProfile",
                "-Command",
                f'Start-Process -FilePath "{path}" -Verb Print',
            ],
            check=True,
            capture_output=True,
            text=True,
        )


def print_pdf_bytes(data: bytes, *, job_name: str = "priznanica") -> None:
    """Queue *data* on the default OS printer. Runs on the machine hosting the API."""
    with tempfile.NamedTemporaryFile(mode="wb", suffix=".pdf", prefix=f"{job_name}_", delete=False) as tmp:
        tmp.write(data)
        path = tmp.name

    try:
        if sys.platform == "win32":
            _print_windows(path)
        elif sys.platform == "darwin":
            subprocess.run(["lpr", path], check=True, capture_output=True, text=True)
        else:
            subprocess.run(["lp", path], check=True, capture_output=True, text=True)
    except (OSError, subprocess.CalledProcessError) as exc:
        _safe_unlink(path)
        detail = getattr(exc, "stderr", None) or str(exc)
        raise PrintError(f"Štampanje nije uspelo: {detail}") from exc

    threading.Timer(60.0, _safe_unlink, args=(path,)).start()
