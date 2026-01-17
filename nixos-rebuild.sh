#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR=~/nixos
LOG_FILE=".nixos-switch.log"
DEBUG=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--debug)
            DEBUG=1
            shift
            ;;
        *)
            FLAKE_TARGET="$1"
            shift
            ;;
    esac
done


# Require a flake target (hostname)
if [[ -z "${FLAKE_TARGET:-}" ]]; then
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

# Format all nix files
echo "Formatting nix files..."
nix run nixpkgs#nixfmt-tree -- .

# Stage nix files so flakes can see untracked files
echo "Staging nix files for evaluation..."
git add '*.nix'

# Show full diff (exactly what will be committed)
git diff --cached | vim -

# Rebuild and capture log
echo "Rebuilding NixOS flake '$FLAKE_TARGET'..."

if [[ "$DEBUG" -eq 1 ]]; then
    sudo nixos-rebuild switch --flake ".#$FLAKE_TARGET" |& tee "$LOG_FILE"
    BUILD_STATUS=${PIPESTATUS[0]}
else
    sudo nixos-rebuild switch --flake ".#$FLAKE_TARGET" &> "$LOG_FILE"
    BUILD_STATUS=$?
fi

if [[ "$BUILD_STATUS" -ne 0 ]]; then
    echo "Errors during rebuild:"
    grep --color=always "error" "$LOG_FILE" || true

    # Safely unstage nix files
    git restore --staged '*.nix' 2>/dev/null || true

    read -p "Open log? (y/n): " confirm
    if [[ "$confirm" =~ ^[yY](es)?$ ]]; then
        vim "$LOG_FILE"
    fi

    popd >/dev/null
    exit 1
fi

echo "NixOS rebuild completed successfully."

# Prompt for commit message
echo "Enter commit message:"
read -r COMMIT_MSG
git commit -m "$COMMIT_MSG"

# Return to original directory
popd >/dev/null

echo "Done!"

