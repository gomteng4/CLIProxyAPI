#!/bin/sh
set -e

AUTH_DIR=/CLIProxyAPI/.cli-proxy-api
mkdir -p "$AUTH_DIR"

if [ -n "$CODEX_AUTH_BASE64" ]; then
  # CLIProxyAPI 는 파일명으로 provider 인식 — codex-{email}-plus.json 패턴
  TARGET="$AUTH_DIR/codex-account.json"
  echo "$CODEX_AUTH_BASE64" | base64 -d > "$TARGET"
  # 디코드된 JSON 에서 email 읽어서 정확한 파일명으로 복사
  EMAIL=$(grep -o '"email":"[^"]*"' "$TARGET" | head -1 | sed 's/"email":"//;s/"//')
  if [ -n "$EMAIL" ]; then
    PROPER="$AUTH_DIR/codex-${EMAIL}-plus.json"
    cp "$TARGET" "$PROPER"
    rm "$TARGET"
    echo "[entrypoint] Auth installed: $PROPER ($(wc -c < $PROPER) bytes)"
  else
    # email 추출 실패 시 그대로 유지
    echo "[entrypoint] Auth installed (fallback name): $TARGET ($(wc -c < $TARGET) bytes)"
  fi
  ls -la $AUTH_DIR
else
  echo "[entrypoint] WARN: CODEX_AUTH_BASE64 not set"
fi

exec ./CLIProxyAPI
