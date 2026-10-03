# Rosé Pine Glass SDDM theme

This is the editable source of Sanguinius's login screen. It uses a compact
440 × 600 px left panel, 90% `#13111b` glass, 16 px corners, JetBrains Mono,
and the shell's Rosé Pine palette. Panel dimensions shrink to fit small screens.

Edit `theme.conf` for appearance and behavior. The most useful settings are:

| Setting | Meaning |
| --- | --- |
| `FormOpacity` | Panel opacity: `0.9` is 90%; `1.0` is solid |
| `FormPosition` | `left`, `center`, or `right` |
| `FormWidth`, `FormHeight`, `FormMargin` | Panel dimensions and screen-edge gap |
| `FormPadding`, `FormSpacing` | Internal padding and gaps |
| `RoundCorners` | Panel and input corner radius |
| `Font`, `FontSize`, `TimeFontSize`, `DateFontSize` | Typography |
| `InputOpacity`, `InputWidthRatio` | Input surface opacity and relative width |
| `PartialBlur`, `Blur`, `BlurMax` | Blur behind the panel; `Blur` ranges from 0 to 1 |
| `AnimationDuration` | Control transitions in milliseconds |
| `…Color` | Individual Rosé Pine surface, text and accent colors |

For layout changes, edit `Main.qml` and `Components/LoginForm.qml`.
`Components/Input.qml` owns password entry and login; `SessionButton.qml` owns
session selection. Login, last-user selection, password focus, Caps Lock and
failure messages retain Astronaut's implementation. SDDM's PAM configuration
remains managed separately in `services.nix`.

Preview from any directory:

```sh
/home/sheke/.config/nix-config/scripts/preview-sddm.sh
```

Close and relaunch the preview after edits. Test mode does not authenticate;
the available sessions and power capabilities can differ from the real greeter.
Power actions are shown only when SDDM reports the corresponding capability.
Previews do not need sudo or rebuilds.

The source wallpaper path in `theme.conf` is relative to this folder. The Nix
package copies `stylix.image` into the theme and writes `theme.conf.user` with
only the installed wallpaper path overridden. All other settings and QML are
copied directly from this folder; there are no build-time QML substitutions.
Selecting a wallpaper in the running shell does not change `stylix.image`.

Apply after reviewing the preview:

```sh
sudo nixos-rebuild switch --flake path:/home/sheke/.config/nix-config#sanguinius
```

## Provenance and license

The controls and SVG assets were copied from
[Keyitdev/sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme)
at commit `abb3163c724935af888ba5ea9ac0c4f22afd8048`, as packaged by the locked
nixpkgs input. The controls retain upstream copyright notices. The local layout,
configuration and modifications are distributed under GPL-3.0-or-later; the
license is included in `LICENSE`. The wallpaper remains the repository's
separate Stylix asset.
