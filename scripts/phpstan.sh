#!/usr/bin/env bash
# Run PHPStan inside Ddev or Docker when available, otherwise via local PHP.
# Usage: phpstan.sh [optional path to analyse, default: full project]
# Run from repository root. Set COMPOSER_ROOT (e.g. backend) if Composer root is a subdir.
set -e
# When plugin lives in repo: plugin/scripts/ -> ../../ = repo root. When plugin is at workspace root: script/ -> .. = repo root.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd || cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"
COMPOSER_ROOT="${COMPOSER_ROOT:-}"
if [ -z "$COMPOSER_ROOT" ] && [ -f "backend/composer.json" ]; then
  COMPOSER_ROOT="backend"
fi
ROOT="${COMPOSER_ROOT:-.}"
if [ -n "$ROOT" ] && [ "$ROOT" != "." ]; then
  BIN="$ROOT/bin/phpstan"
  RUN_PATH="$ROOT"
else
  BIN="vendor/bin/phpstan"
  RUN_PATH="."
fi
if command -v ddev >/dev/null 2>&1 && ddev describe >/dev/null 2>&1; then
  if [ -n "$1" ]; then
    ddev exec "php -dmemory_limit=512M $BIN analyse $*"
  else
    ddev exec "php -dmemory_limit=512M $BIN analyse"
  fi
elif [ -f "$BIN" ] || [ -f "$ROOT/vendor/bin/phpstan" ]; then
  [ -f "$ROOT/vendor/bin/phpstan" ] && BIN="$ROOT/vendor/bin/phpstan"
  php -dmemory_limit=512M "$BIN" analyse "$@"
else
  echo "PHPStan not found at $BIN or $ROOT/vendor/bin/phpstan. Set COMPOSER_ROOT if your Composer root is a subdirectory." >&2
  exit 1
fi
