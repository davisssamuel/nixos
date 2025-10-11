#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR=~/nixos
LOG_FILE=".nixos-switch.log"

# Require a system/flake target argument
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <flake-target> (e.g., my-hostname)"
    exit 1
fi
FLAKE_TARGET="$1"

# Go to your NixOS configuration directory
pushd "$CONFIG_DIR" >/dev/null

# Exit early if no changes in nix files
if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd >/dev/null
    exit 0
fi

# Autoformat nix files using nixfmt-tree
echo "Autoformatting nix files..."
# if ! nix run nixpkgs#nixfmt-tree -- .; then
if ! find . -type f -name '*.nix' ! -name 'hardware-configuration.nix' -print0 | xargs -0 nix run nixpkgs#nixfmt-tree -- ; then
    echo "Autoformatting failed!"
    popd >/dev/null
    exit 1
fi

# Show all changes in vim
git diff -U0 '*.nix' | vim -

echo "Rebuilding NixOS flake '$FLAKE_TARGET'..."

# Attempt rebuild and log output
if sudo nixos-rebuild switch --flake ".#$FLAKE_TARGET" &> "$LOG_FILE"; then
    echo -e "NixOS rebuild for flake '$FLAKE_TARGET' completed successfully!\n"
else
    echo "Errors during rebuild:"
    grep --color=always "error" "$LOG_FILE" || true

    # Restore nix files to unstaged state for next run
    sudo git restore --staged **/*.nix || true

    # Optionally open full log
    read -p "Open log? (y/N): " confirm
    if [[ "$confirm" =~ ^[yY](es)?$ ]]; then
        vim "$LOG_FILE"
    fi

    popd >/dev/null
    exit 1
fi

# Prompt for commit message
echo "Enter commit message for these changes:"
read -r COMMIT_MSG

# Include current generation metadata in the commit message
current=$(nixos-rebuild list-generations --flake ".#$FLAKE_TARGET" | grep current)
git commit -am "$COMMIT_MSG ($current)"

# Back to original directory
popd >/dev/null

echo "Done!"

