#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR=~/nixos
LOG_FILE=".nixos-switch.log"

# Require a flake target (hostname)
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <flake-target> (e.g. hostname)"
    exit 1
fi
FLAKE_TARGET="$1"

# Enter flake directory
pushd "$CONFIG_DIR" >/dev/null

# Detect both modified and untracked nix files
if ! git status --porcelain | grep -q '\.nix$'; then
    echo "No changes detected, exiting."
    popd >/dev/null
    exit 0
fi

# Autoformat all nix files
echo "Autoformatting nix files..."
nix run nixpkgs#nixfmt-tree -- .

# Stage nix files so flakes can see untracked files
echo "Staging nix files for evaluation..."
git add '*.nix'

# Show full diff (exactly what will be committed)
git diff --cached | vim -

echo "Rebuilding NixOS flake '$FLAKE_TARGET'..."

# Rebuild and capture log
if sudo nixos-rebuild switch --flake ".#$FLAKE_TARGET" &> "$LOG_FILE"; then
    echo "NixOS rebuild completed successfully."
else
    echo "Errors during rebuild:"
    grep --color=always "error" "$LOG_FILE" || true

    # Safely unstage nix files (ignore errors)
    git restore --staged '*.nix' 2>/dev/null || true

    # Optional log viewer
    read -p "Open log? (y/N): " confirm
    if [[ "$confirm" =~ ^[yY](es)?$ ]]; then
        vim "$LOG_FILE"
    fi

    popd >/dev/null
    exit 1
fi

# Prompt for commit message
echo "Enter commit message:"
read -r COMMIT_MSG
git commit -m "$COMMIT_MSG"

# Return to original directory
popd >/dev/null

echo "Done!"

