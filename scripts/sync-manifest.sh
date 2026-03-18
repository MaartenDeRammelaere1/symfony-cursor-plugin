#!/usr/bin/env bash
# Sync plugin manifest for Open Plugins compatibility.
# Run after editing .cursor-plugin/plugin.json so .plugin/plugin.json stays in sync.
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
cp "$PLUGIN_ROOT/.cursor-plugin/plugin.json" "$PLUGIN_ROOT/.plugin/plugin.json"
echo "Synced .cursor-plugin/plugin.json -> .plugin/plugin.json"
