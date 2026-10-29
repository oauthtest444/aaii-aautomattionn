#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${CHROME_DEBUG_PORT:-9222}"
PROFILE="${CHROME_PROFILE_DIR:-/tmp/chrome-mcp-profile}"
LOG="${CHROME_LOG_FILE:-/tmp/chrome-mcp.log}"
MCP_URL="${CHROME_DEBUG_URL:-http://127.0.0.1:${PORT}}"

is_up() {
  curl -fsS --max-time 2 "${MCP_URL}/json/version" >/dev/null 2>&1
}

if ! is_up; then
  CHROME_BIN="${CHROME_BIN:-}"
  if [ -z "$CHROME_BIN" ]; then
    CHROME_BIN="$(command -v google-chrome-stable || command -v google-chrome || command -v chromium || command -v chromium-browser || true)"
  fi
  if [ -z "$CHROME_BIN" ]; then
    echo "ERROR: Chrome/Chromium binary not found" >&2
    exit 1
  fi

  mkdir -p "$PROFILE"
  nohup "$CHROME_BIN" \
    --headless=new \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --remote-debugging-address=127.0.0.1 \
    --remote-debugging-port="$PORT" \
    --user-data-dir="$PROFILE" \
    about:blank >"$LOG" 2>&1 &
fi

for _ in $(seq 1 30); do
  is_up && break
  sleep 1
done

if ! is_up; then
  echo "ERROR: Chrome DevTools not reachable at ${MCP_URL}" >&2
  tail -50 "$LOG" >&2 2>/dev/null || true
  exit 1
fi

python3 - "${REPO_ROOT}/opencode.json" "${MCP_URL}" <<'PY'
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
url = sys.argv[2]
cfg = json.loads(path.read_text()) if path.exists() else {
    "$schema": "https://opencode.ai/config.json"
}
cfg.setdefault("$schema", "https://opencode.ai/config.json")
cfg.setdefault("autoupdate", False)
cfg.setdefault("permission", "allow")
cfg.setdefault("share", "disabled")
mcp = cfg.setdefault("mcp", {})
mcp["chrome-devtools"] = {
    "type": "local",
    "command": [
        "npx",
        "-y",
        "chrome-devtools-mcp@latest",
        f"--browser-url={url}",
    ],
}
path.write_text(json.dumps(cfg, indent=2) + "\n")
PY

if ! opencode mcp list 2>/dev/null | grep -q "chrome-devtools.*connected"; then
  echo "ERROR: chrome-devtools MCP is not connected" >&2
  opencode mcp list 2>/dev/null || true
  exit 1
fi

echo "Chrome DevTools ready at ${MCP_URL}"
