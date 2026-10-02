#!/usr/bin/env python3
"""Apply the versioned dock migration without resetting other DMS session state."""

import argparse
import json
import os
from pathlib import Path
import tempfile


def atomic_write(path, content):
    fd, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
    try:
        with os.fdopen(fd, "w") as stream:
            os.fchmod(stream.fileno(), 0o600)
            stream.write(content)
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def migrate(state_dir, defaults):
    marker = state_dir / ".rose-pine-dock-v2"
    if marker.exists():
        return False
    session = state_dir / "session.json"
    if session.is_symlink():
        raise ValueError("DMS session.json must be a writable regular file")
    original = session.read_text()
    data = json.loads(original)
    pins = json.loads(defaults.read_text())["pinnedApps"]
    if not isinstance(data, dict) or not isinstance(pins, list):
        raise ValueError("Invalid session or dock defaults")
    backup = state_dir / "session.before-rose-pine-dock-v2.json"
    if not backup.exists():
        atomic_write(backup, original)
    data["pinnedApps"] = pins
    atomic_write(session, json.dumps(data, indent=2) + "\n")
    atomic_write(marker, "2\n")
    return True


def migrate_dolphin(state_dir):
    marker = state_dir / ".rose-pine-dolphin-v1"
    if marker.exists():
        return False
    session = state_dir / "session.json"
    if session.is_symlink():
        raise ValueError("DMS session.json must be a writable regular file")
    original = session.read_text()
    data = json.loads(original)
    if not isinstance(data, dict) or not isinstance(data.get("pinnedApps", []), list):
        raise ValueError("Invalid DMS dock pins")
    changed = "thunar" in data.get("pinnedApps", [])
    if changed:
        pins = []
        for pin in data["pinnedApps"]:
            if pin == "org.kde.dolphin":
                continue
            replacement = "org.kde.dolphin" if pin == "thunar" else pin
            if replacement == "org.kde.dolphin" and replacement in pins:
                continue
            pins.append(replacement)
        backup = state_dir / "session.before-rose-pine-dolphin-v1.json"
        if not backup.exists():
            atomic_write(backup, original)
        data["pinnedApps"] = pins
        atomic_write(session, json.dumps(data, indent=2) + "\n")
    atomic_write(marker, "1\n")
    return changed


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("state_dir", type=Path)
    parser.add_argument("defaults", type=Path)
    args = parser.parse_args()
    migrate(args.state_dir, args.defaults)
    migrate_dolphin(args.state_dir)
