#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${1:-.}"
DRY_RUN="${DRY_RUN:-0}"

EXTENSIONS=(
  "*.pas"
  "*.dfm"
  "*.dpr"
  "*.inc"
)

usage() {
  cat <<'EOF'
Usage:
  ./convert_ansi_to_utf8.sh [root_dir]

Behavior:
  - Recurses under root_dir (default: current directory)
  - Scans Delphi source files (*.pas, *.dfm, *.dpr, *.inc)
  - Detects files that are not valid UTF-8
  - Converts each such file from Windows-1252 to UTF-8
  - Saves a backup as <filename>.bak before overwriting

Options via environment:
  DRY_RUN=1   Show files that would be converted without modifying them

Notes:
  - This assumes non-UTF-8 files are encoded as Windows-1252.
  - Review backups after conversion if any file contains unusual characters.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if ! command -v iconv >/dev/null 2>&1; then
  echo "Error: iconv is required but not installed." >&2
  exit 1
fi

if [[ ! -d "$ROOT_DIR" ]]; then
  echo "Error: directory not found: $ROOT_DIR" >&2
  exit 1
fi

build_find_args() {
  local first=1
  for pattern in "${EXTENSIONS[@]}"; do
    if [[ $first -eq 1 ]]; then
      printf -- "-iname %q" "$pattern"
      first=0
    else
      printf -- " -o -iname %q" "$pattern"
    fi
  done
}

convert_file() {
  local file="$1"
  local tmp_file
  tmp_file="$(mktemp)"

  if ! iconv -f UTF-8 -t UTF-8 "$file" >/dev/null 2>&1; then
    if [[ "$DRY_RUN" == "1" ]]; then
      echo "Would convert: $file"
      rm -f "$tmp_file"
      return 0
    fi

    cp -p "$file" "$file.bak"   #kt //codex 7/30/26
    iconv -f WINDOWS-1252 -t UTF-8 "$file" > "$tmp_file"   #kt //codex 7/30/26
    cat "$tmp_file" > "$file"   #kt //codex 7/30/26
    rm -f "$tmp_file"
    echo "Converted: $file"
  else
    rm -f "$tmp_file"
  fi
}

export DRY_RUN
export -f convert_file

FIND_EXPR="$(build_find_args)"

while IFS= read -r -d '' file; do
  convert_file "$file"
done < <(eval "find \"\$ROOT_DIR\" -type f \\( $FIND_EXPR \\) -print0")
