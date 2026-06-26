#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
TARGET_DIR="${HOME:?HOME is not set}"
DRY_RUN=0
DELETE=0
ADOPT=0
PACKAGES=()

usage() {
  printf 'Usage: %s [--dry-run] [--delete] [--adopt] [PACKAGE ...]\n' "${0##*/}"
  printf '\n'
  printf 'Symlink dotfile packages into $HOME using GNU Stow.\n'
  printf 'When no package is provided, every top-level non-hidden directory is used.\n'
  printf '\n'
  printf 'Options:\n'
  printf '  --dry-run  Show what Stow would do without changing links.\n'
  printf '  --delete   Unstow packages instead of installing them.\n'
  printf '  --adopt    Move existing target files into this repo before stowing.\n'
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

discover_packages() {
  local path name

  for path in "$DOTFILES_DIR"/*; do
    [[ -d "$path" ]] || continue
    name=${path##*/}
    [[ "$name" == .* ]] && continue
    printf '%s\n' "$name"
  done
}

main() {
  local stow_args=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run|-n) DRY_RUN=1 ;;
      --delete|-D) DELETE=1 ;;
      --adopt) ADOPT=1 ;;
      -h|--help)
        usage
        exit 0
        ;;
      --) shift; PACKAGES+=("$@"); break ;;
      -*) die "unknown option: $1" ;;
      *) PACKAGES+=("$1") ;;
    esac
    shift
  done

  need_cmd stow

  if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    while IFS= read -r package; do
      PACKAGES+=("$package")
    done < <(discover_packages)
  fi

  [[ ${#PACKAGES[@]} -gt 0 ]] || die "no packages found in $DOTFILES_DIR"

  stow_args+=(--dir "$DOTFILES_DIR" --target "$TARGET_DIR" --verbose)
  if (( DRY_RUN )); then
    stow_args+=(--simulate)
  fi
  if (( DELETE )); then
    stow_args+=(--delete)
  else
    stow_args+=(--restow)
    if (( ADOPT )); then
      stow_args+=(--adopt)
    fi
  fi

  stow "${stow_args[@]}" "${PACKAGES[@]}"
}

main "$@"
