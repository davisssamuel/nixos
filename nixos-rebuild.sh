#!/usr/bin/env bash

set -euo pipefail

FLAKE_TARGET=""
CONFIG_DIR=~/nixos
LOG_FILE=".nixos-switch.log"
DEBUG=0
BUILD_STATUS=0

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--debug)
            DEBUG=1
            shift
            ;;
        *)
			if [[ -n "$FLAKE_TARGET" ]]; then
                echo "Multiple flake targets specified"
                exit 1
            fi
            FLAKE_TARGET="$1"
            shift
            ;;
    esac
done

# Require a flake target (hostname)
if [[ -z "${FLAKE_TARGET}" ]]; then
    echo "Usage: $0 [--debug|-d] <flake-target> (i.e. config in nixosConfigurations)"
    exit 1
fi

# Runs `nixos-rebuild switch` and sets BUILD_STATUS
run_rebuild() {
    echo "Rebuilding NixOS flake: $FLAKE_TARGET..."

    if [[ "$DEBUG" -eq 1 ]]; then
        sudo nixos-rebuild switch --flake ".#$FLAKE_TARGET" |& tee "$LOG_FILE"
        BUILD_STATUS=${PIPESTATUS[0]}
    else
        sudo nixos-rebuild switch --flake ".#$FLAKE_TARGET" &> "$LOG_FILE"
        BUILD_STATUS=$?
    fi
}

# Handles a failed rebuild: shows errors, optionally unstages nix files, optionally opens the log, then exits
handle_rebuild_failure() {
    echo "Errors during rebuild:"
    grep --color=always "error" "$LOG_FILE" || true

    if [[ "${1:-}" == "--unstage" ]]; then
        # Safely unstage nix files
        git restore --staged '*.nix' 2>/dev/null || true
    fi

    read -p "Open log? (y/n): " confirm
    if [[ "$confirm" =~ ^[yY](es)?$ ]]; then
        vi "$LOG_FILE"
    fi

    popd >/dev/null
    exit 1
}

# Enter flake directory
pushd "$CONFIG_DIR" >/dev/null

# Rebuild without any changes
if ! git status --porcelain | grep -q '\.nix$'; then
    echo "No changes detected."

    run_rebuild

    if [[ "$BUILD_STATUS" -ne 0 ]]; then
        handle_rebuild_failure
    fi

    echo "NixOS rebuild completed successfully."
    popd >/dev/null
    echo "Done!"
    exit 0
fi

# Format all nix files
echo "Formatting nix files..."
nix run nixpkgs#nixfmt-tree -- .

# Stage nix files so flakes can see untracked files
echo "Staging nix files for evaluation..."
git add '*.nix'

# Show what will be committed
git diff --cached | vi -

run_rebuild

if [[ "$BUILD_STATUS" -ne 0 ]]; then
    # All changes have been staged, so failures need to unstage them
    handle_rebuild_failure --unstage
fi

echo "NixOS rebuild completed successfully."

echo "Enter commit message:"
read -r COMMIT_MSG
git commit -m "$COMMIT_MSG"

# Return to original directory
popd >/dev/null
echo "Done!"
