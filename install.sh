#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEST="${XDG_DATA_HOME:-$HOME/.local/share}/archoclp"
BIN="${XDG_BIN_HOME:-$HOME/.local/bin}"
mkdir -p "$DEST" "$BIN"
install -m 0755 "$ROOT/archoclp.py" "$DEST/archoclp.py"
install -m 0644 "$ROOT/models.json" "$DEST/models.json"
cat > "$BIN/archoclp" <<EOF
#!/usr/bin/env bash
set -euo pipefail
exec python3 "$DEST/archoclp.py" "\$@"
EOF
chmod 0755 "$BIN/archoclp"
printf 'Installed ArchOCLP command to %s/archoclp\n' "$BIN"
printf 'Make sure %s is in PATH.\n' "$BIN"
