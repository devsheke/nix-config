# Fingerprint authentication

Sanguinius enables `fprintd`, which enables fingerprint authentication by
default for NixOS PAM services such as `sudo`, `polkit-1`, console `login`,
and `su`. Password authentication remains available.

Hyprlock uses its native parallel fingerprint backend, enabled by
`auth.fingerprint.enabled` in the local `~/.config/hypr/hyprlock.conf`.
The matching repository config is
`modules/packages/home-manager/rose-pine-shell/hyprlock.conf`. Its PAM
service handles passwords only, so it does not compete with the native
backend for the fingerprint reader.

SDDM uses a separate `sddm-password` authentication stack with fingerprint
authentication disabled. Its account, password-change, and session stacks
continue to use the standard `login` service. Disabling only SDDM's
`fprintAuth` option is insufficient because its upstream auth stack delegates
to `login`.

Apply the configuration:

```sh
sudo nixos-rebuild switch --flake path:/home/sheke/.config/nix-config#sanguinius
```

Enroll a finger as your normal user, following the scanner prompts:

```sh
fprintd-enroll
fprintd-list sheke
fprintd-verify
```

The next Hyprlock invocation can use the enrolled fingerprint. For `sudo`
or graphical polkit prompts, scan when prompted; a failed or timed-out scan
falls back to the password according to the PAM service's behavior.
