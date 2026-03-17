#!/usr/bin/env bash
# Run ECS or PHP-CS-Fixer inside Ddev or Docker when available, otherwise via local PHP.
# Usage: cs-fix.sh [optional path to fix, default: Composer root]
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
TARGET="${1:-$ROOT}"
[ -z "$TARGET" ] && TARGET="."
# Path relative to Composer root for commands that run inside ROOT
TARGET_REL="${TARGET#$ROOT/}"
[ -z "$TARGET_REL" ] && TARGET_REL="."
run_cmd() {
  local cmd="$1"
  if command -v ddev >/dev/null 2>&1 && ddev describe >/dev/null 2>&1; then
    if [ "$ROOT" = "." ]; then
      ddev exec "$cmd"
    else
      ddev exec "cd $ROOT && $cmd"
    fi
  else
    ( cd "$REPO_ROOT/$ROOT" && eval "$cmd" )
  fi
}
# Prefer ECS if present, then PHP-CS-Fixer
if [ -f "$REPO_ROOT/$ROOT/vendor/bin/ecs" ]; then
  run_cmd "php vendor/bin/ecs check --fix $TARGET_REL"
elif [ -f "$REPO_ROOT/$ROOT/bin/php-cs-fixer" ]; then
  run_cmd "php bin/php-cs-fixer fix $TARGET_REL"
elif [ -f "$REPO_ROOT/$ROOT/vendor/bin/php-cs-fixer" ]; then
  run_cmd "php vendor/bin/php-cs-fixer fix $TARGET_REL"
else
  echo "Neither ECS nor PHP-CS-Fixer found under $ROOT. Set COMPOSER_ROOT if your Composer root is a subdirectory." >&2
  exit 1
fi
