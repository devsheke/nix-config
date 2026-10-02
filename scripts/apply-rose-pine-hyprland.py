#!/usr/bin/env python3
"""Preview or apply the shell integration to a separately managed Lua config."""

import argparse
from datetime import datetime, timezone
import difflib
from pathlib import Path
import shutil


def replace_once(text, before, after):
    if before not in text and after and after in text:
        return text
    if text.count(before) != 1:
        raise ValueError(f"Expected exactly one occurrence of {before!r}")
    return text.replace(before, after, 1)


def changes(root):
    names = ["autostart", "programs", "keybinds", "appearance", "windowrules"]
    original = {name: (root / "modules" / f"{name}.lua").read_text() for name in names}
    updated = original.copy()

    for command in [
        "swaybg -i ~/Pictures/sanguinius-motif.png -m fill",
        "elephant",
        "walker --gapplication-service",
        "waybar",
        "swaync",
        "nm-applet",
        "blueman-applet",
    ]:
        line = f'\thl.exec_cmd("{command}")\n'
        updated["autostart"] = updated["autostart"].replace(line, "")
    updated["programs"] = replace_once(
        updated["programs"], 'menu = "walker"', 'menu = "dms ipc call spotlight toggle"'
    )
    updated["programs"] = replace_once(
        updated["programs"], 'file_manager = "thunar"', """file_manager = 'xdg-open "$HOME"'"""
    )
    updated["windowrules"] = replace_once(
        updated["windowrules"], 'name = "float-thunar"', 'name = "float-dolphin"'
    )
    updated["windowrules"] = replace_once(
        updated["windowrules"], 'class = "^(thunar)$"', r'class = "^(org\\.kde\\.dolphin|dolphin)$"'
    )

    updated["keybinds"] = "".join(
        line for line in updated["keybinds"].splitlines(keepends=True)
        if ".waybar-wrapped" not in line
    )
    marker = "-- Rose Pine shell shortcuts."
    if marker not in updated["keybinds"]:
        shortcut = 'hl.bind(main_mod .. " + Space", hl.dsp.exec_cmd(programs.menu))\n'
        updated["keybinds"] = replace_once(
            updated["keybinds"], shortcut,
            shortcut + marker + '\n'
            'hl.bind(main_mod .. " + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))\n'
            'hl.bind(main_mod .. " + C", hl.dsp.exec_cmd("dms ipc call control-center toggle"))\n'
            'hl.bind(main_mod .. " + comma", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))\n'
        )

    marker = "-- Rose Pine shell surfaces."
    if marker not in updated["appearance"]:
        updated["appearance"] += '''
-- Rose Pine shell surfaces.
-- DMS animates its own surfaces; avoid a second compositor animation.
hl.layer_rule({
	name = "rose-pine-shell",
	match = { namespace = "^dms:.*" },
	blur = true,
	ignore_alpha = 0.2,
	no_anim = true,
})
'''

    marker = "-- Rose Pine shell settings windows."
    if marker not in updated["windowrules"]:
        updated["windowrules"] += '''
-- Rose Pine shell settings windows.
hl.window_rule({
	name = "float-dms-settings",
	match = { class = "^(com\\\\.danklinux\\\\.dms)$" },
	float = true,
})
'''
    return {
        root / "modules" / f"{name}.lua": (original[name], updated[name])
        for name in names if original[name] != updated[name]
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config-dir", type=Path, default=Path.home() / ".config/hypr")
    parser.add_argument("--apply", action="store_true", help="Back up originals and apply changes")
    args = parser.parse_args()
    root = args.config_dir.resolve()
    pending = changes(root)
    if not pending:
        print("Hyprland shell integration is already installed.")
        return
    for path, (before, after) in pending.items():
        print("".join(difflib.unified_diff(
            before.splitlines(keepends=True), after.splitlines(keepends=True),
            fromfile=str(path), tofile=str(path),
        )), end="")
    if not args.apply:
        print("Preview only. Use --apply to back up and write these changes.")
        return
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    backup = root / "backups" / f"rose-pine-shell-{stamp}"
    backup.mkdir(parents=True, exist_ok=False)
    for path in pending:
        dest = backup / path.relative_to(root)
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, dest)
    for path, (_, after) in pending.items():
        path.write_text(after)
    print(f"Backup: {backup}")
    print("Reload Hyprland after DMS is installed; this script does not reload the session.")


if __name__ == "__main__":
    main()
