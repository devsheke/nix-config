# Rose Pine glass shell

Sanguinius uses DankMaterialShell 1.6.2 from the locked upstream `stable` flake,
with Quickshell 0.3.1 from the existing nixpkgs input. The shell module is
`modules/packages/home-manager/rose-pine-shell.nix`; enable it with
`programs.rose-pine-shell.enable`. Its `wallpaper` option defaults to Stylix's
image, and `pinnedApps` accepts desktop-entry IDs without `.desktop`.

## Apply

Build before activating. The `path:` flake form includes newly created files
without requiring them to be staged in Git.

```sh
nix build path:/home/sheke/.config/nix-config#nixosConfigurations.sanguinius.config.system.build.toplevel --no-link
sudo nixos-rebuild switch --flake path:/home/sheke/.config/nix-config#sanguinius
python /home/sheke/.config/nix-config/scripts/apply-rose-pine-hyprland.py --apply
hyprctl reload
```

The Lua integration script previews its diff when run without `--apply`. It
backs up the five edited files under `~/.config/hypr/backups/rose-pine-shell-*`
before writing, preserves unrelated bindings/decorations, and does not reload
Hyprland itself. It can be rerun without adding duplicate rules or bindings.

The matching Hyprlock config is
`modules/packages/home-manager/rose-pine-shell/hyprlock.conf`. It uses the
same JetBrains Mono font, Rosé Pine palette, 90% dark panel surface, 16 px
corners and 180 ms fades, with a blurred desktop behind a centered clock and
unlock panel. Fingerprint prompts and the clickable keyboard layout sit below
the password field. A bottom-center battery label reads BAT0's percentage and
charging status directly from sysfs every ten seconds. Hyprlock remains a
regular local config; apply later edits
after backing up the current file:

```sh
cp -p ~/.config/hypr/hyprlock.conf ~/.config/hypr/hyprlock.conf.backup-$(date +%Y%m%dT%H%M%S)
install -m 644 /home/sheke/.config/nix-config/modules/packages/home-manager/rose-pine-shell/hyprlock.conf ~/.config/hypr/hyprlock.conf
```

The next invocation of Hyprlock loads the new config.

On first activation, stop the old session's manually launched Waybar, SwayNC,
swaybg, Walker, Elephant, nm-applet and blueman-applet processes, then start
`systemctl --user start dms.service`. A fresh login also uses the new startup
configuration. DMS starts once through the graphical-session systemd target;
do not add `dms run` to the Hyprland autostart file.

## Editable SDDM theme

The `rose-pine-glass` login theme lives in `hosts/sanguinius/sddm-theme`.
Edit `theme.conf` for panel opacity, size, position, padding, corner radius,
fonts and Rosé Pine colors. Edit `Main.qml` and `Components/LoginForm.qml`
for layout changes. The default is a compact 440 × 600 px left panel with
90% `#13111b` glass, 16 px corners, partial blur and JetBrains Mono.
Astronaut's user, password, session and power controls are kept locally with
their original license notices. Authentication configuration remains in
`hosts/sanguinius/services.nix`.

Preview without a rebuild or sudo, then close and relaunch after each edit:

```sh
/home/sheke/.config/nix-config/scripts/preview-sddm.sh
```

`hosts/sanguinius/sddm-rose-pine.nix` packages the local files directly and
copies `stylix.image` into the installed theme. Only the installed wallpaper
path is overridden in `theme.conf.user`; QML is no longer patched during the
build. The source preview uses the repository wallpaper via a relative path.
Runtime shell wallpaper selections do not automatically update SDDM.
Apply using the NixOS rebuild command above. More editing details and source
provenance are in `hosts/sanguinius/sddm-theme/README.md`.

## Design and behavior

The attached 36 px bar uses JetBrains Mono throughout, approximately 13 px
bar text, 13 px workspace symbols, and 14 px custom status icons. Its left
section is the square Nix power button, square
workspace buttons with no gaps between them, and focused app/title. The clock
is centered independently and reads `Fri Oct 02 11:27 2026`. Its popout contains
only date, time, and a calendar. Workspaces 1–5 remain visible; additional
positive workspaces appear when active or occupied. Workspace app thumbnails
were removed following the visual review, keeping each symbol centered.

The right section contains single-line, ellipsized media text; independent
Wi-Fi, Bluetooth and volume buttons; Stats; a vertical battery icon;
notifications; a separate control-center button; and the tray at the far right.
The Nix button fills the same 36 × 36 px area as each workspace button. Tray
icons have 4 px extra spacing. Bar tooltips use input-transparent layer surfaces
below the bar, with a short fade and slide. Opening a popover immediately hides
tooltips and suppresses them until it closes.

The 420 px control center starts with the media card, followed by cards for
Wi-Fi, Bluetooth, secured hotspot, VPN, DND, microphone, brightness, sound,
battery and power profiles. The dedicated media popover contains only the
player card. Power menu icons are 18 px in lists and 20 px in grids.
Device details use the native DMS components. The hotspot form checks the
password length and asks before disconnecting the existing Wi-Fi connection.
Metrics acquire polling references while open and release them on close;
CPU, memory, disk use/activity and temperatures have labeled icons. Missing
sensor readings are shown as unavailable. NVIDIA usage, VRAM, temperature and
power come from bounded, read-only `nvidia-smi` CSV queries every five seconds,
only while the metrics popover is open. Driver failures clear the readings
and show an unavailable state. Long popouts scroll.

Grouped buttons have fully rounded ends in every state. The dock uses 44 px
Papirus icons, 8 px spacing and a 12 px bottom gap, grouped running windows,
and edge-triggered auto-hide. Its migrated pin order is Ghostty, Dolphin,
Brave, Obsidian, ONLYOFFICE, ChatGPT, Spotify, Steam. Bar/dock/panel opacity
remains 85%/80%/90%; shell colors come from Stylix. The primary background
is `#13111b`, a darker Rosé Pine base applied to the bar, dock, and popover
surfaces. Raised cards keep the palette's lighter surface colors.

Custom QML lives beside the module in `rose-pine-shell/qml`. The locked
upstream package is patched during `postInstall` using `shell.patch` with
`--forward --fuzz=0`, after DMS copies QML and DankCommon. Upstream changes that invalidate
patch contexts fail the build rather than silently applying to different code.

Spotlight keeps the desktop undimmed. The pinned DankCalculator 0.3.4 plugin
uses Qalculate for both arithmetic and currency conversions: type
`= (5 + 3) * 2` or `= 100 USD to INR`. Results use plain text, copy via an argv
array with `--`, and debounce queries while discarding older process results.
Calculations time out after eight seconds. Currency rates refresh when needed
and network access is available; cached rates can be used offline, so currency
results should not be treated as live market quotes.

| Shortcut | Action |
| --- | --- |
| Super+Space | Spotlight launcher |
| Super+N | Notification center |
| Super+C | Control center |
| Super+Comma | Settings |
| Super+Shift+L | Existing Hyprlock |

Audio, microphone, brightness, media and workspace keys retain their existing
commands. DMS listens for audio/backlight changes to show overlays. Clicking
the media icon opens the media-only player. On the track title, left click
toggles play/pause, right click advances, and middle click goes back, when
supported by the active player. Volume supports wheel adjustments and
middle-click mute. Weather and clipboard history are disabled.

Appearance settings and the custom theme are Nix-managed. DMS's settings GUI
can preview changes, but saving appearance requires editing the Nix module.
Runtime state is a regular file at
`~/.local/state/DankMaterialShell/session.json`, seeded only when absent:
wallpaper selection, dock pins, DND, and other session controls can persist.
Before DMS starts, a one-time dock migration updates only `pinnedApps`, backs
up the original session to `session.before-rose-pine-dock-v2.json`, and writes
`.rose-pine-dock-v2` last. Later restarts preserve user changes to dock pins.
The Dolphin migration replaces only an existing Thunar pin, preserving its
position and every other session field; its backup is
`session.before-rose-pine-dolphin-v1.json`. Folder defaults and Super+E open
Dolphin. The folder association update preserves all other MIME defaults.
The local calendar is stored in `~/.local/share/khal/calendars/personal`.
No calendar account or sync service is configured.

Stylix's automatic DMS target is disabled because it would make the session
file read-only. This module generates the palette from Stylix explicitly.
DMS's matugen and polkit integration are disabled; existing application themes
and the GNOME authentication agent remain authoritative. Hyprlock remains the
locker, with DMS's lock action pointing to it and idle timers disabled.
XDG autostart overrides also hide the legacy Blueman and NetworkManager
applets, while keeping their underlying system services available.

## Wallpaper provenance

The active revision is `assets/wallpapers/sanguinius-woodblock-restored.png`, an
opaque **3840×2160** PNG. The cleaner generated source was processed locally
with Real-ESRGAN ncnn Vulkan 0.2.0, model `realesrgan-x4plus-anime`, producing
**6688×3764** pixels, then resampled down to the final dimensions with Lanczos.
Desktop-size detail crops were compared against the previous version: the
flame, sword and feather contours are visibly cleaner, with substantially
less background grain. This is AI super-resolution, not native 4K generation;
some fine print texture has been simplified. Composition and 16:10 crop remain
unchanged. See `assets/wallpapers/sanguinius-woodblock-restored.md` for the
reproduction command and source lineage.

The previous revision is `assets/wallpapers/sanguinius-woodblock-clean.png`, an
opaque **3840×2160** PNG. On 2026-10-02 the built-in generator redrew the
emblem with cleaner carved edges and reduced paper grain. It again produced
**1672×941** pixels; the user explicitly selected this cleaner redraw with
Lanczos upscaling. This improves the artwork's visual clarity, but does not
make it native 4K detail. The source is preserved as
`sanguinius-woodblock-clean-generated.png`, with its prompt in
`sanguinius-woodblock-clean.prompt.txt`. The actual 16:10 fill crop was
inspected; both wing tips and the halo remain visible.

Stylix references the restored revision. It was also applied immediately with
`dms ipc call wallpaper set` using the repository asset's absolute path, since
existing writable session state is intentionally not overwritten by Nix.
The previous artwork and its generator source remain available below.

`assets/wallpapers/sanguinius-woodblock.png` is an opaque **3840×2160** PNG,
upscaled with Pillow's Lanczos resampling after explicit user approval.
`sanguinius-woodblock-generated.png` preserves the built-in image generator's
**1672×941** output. The original `~/Pictures/sanguinius-motif.png` is unchanged.
The 16:10 fill crop was visually inspected and preserves both wings and halo.

The final image edit prompt was:

> Edit this wallpaper to deliver an actual 3840 by 2160 pixel PNG. Upscale it to
> 4K UHD with crisp woodblock detail. Preserve the same emblem, colors,
> woodblock texture, flame, sword, feathers and halo. Crucial composition
> change: shrink the entire emblem uniformly so it occupies only 75 percent
> of the canvas width, centered horizontally and vertically, surrounded by
> quiet same dark purple textured paper. The leftmost wing tip must begin at
> least 12.5 percent from the left edge; rightmost at least 12.5 percent from
> the right edge. Keep complete emblem and halo inside central safe region
> for cropping from 16:9 to 16:10. No text, no water, no waves, no landscape,
> no new symbols. Exact requested output resolution 3840x2160, not a smaller
> preview.

Its reference was the first generated woodblock reinterpretation of the
original emblem: Hokusai-inspired carved linework and paper texture, muted
Rose Pine purple/foam/pine/iris/rose/gold, symmetrical winged sword, central
flame/drop, and radial halo, with no ocean scene or lettering.

## Rollback

Stop DMS before starting another notification daemon:

```sh
systemctl --user stop dms.service
sudo nixos-rebuild switch --rollback
```

Restore the five Lua files from the backup printed by the integration script.
For example, replace the timestamp below with that backup's actual directory:

```sh
cp ~/.config/hypr/backups/rose-pine-shell-TIMESTAMP/modules/*.lua ~/.config/hypr/modules/
hyprctl reload
```

Log out and back in to restore the previous autostart processes. Keep DMS's
writable session/calendar data if you want to preserve it for a later retry.
