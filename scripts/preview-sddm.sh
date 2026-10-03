#!/usr/bin/env bash
set -euo pipefail
repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
exec sddm-greeter-qt6 --test-mode --theme "$repo_root/hosts/sanguinius/sddm-theme" "$@"
