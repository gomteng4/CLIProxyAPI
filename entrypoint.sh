#!/bin/sh
set -e

AUTH_DIR=/CLIProxyAPI/.cli-proxy-api
mkdir -p "$AUTH_DIR"

if [ -n "$CODEX_AUTH_BASE64" ]; then
  echo "$CODEX_AUTH_BASE64" | base64 -d > "$AUTH_DIR/codex.json"
  echo "[entrypoint] Decoded CODEX_AUTH_BASE64 to $AUTH_DIR/codex.json ($(wc -c < $AUTH_DIR/codex.json) bytes)"
else
  echo "[entrypoint] WARN: CODEX_AUTH_BASE64 not set"
fi

exec ./CLIProxyAPI
