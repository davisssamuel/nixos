#!/usr/bin/env bash

set -e

# Edit your config
$EDITOR configuration.nix

# cd to your config dir
pushd ~/dotfiles/nixos/

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet '*.nix'; then
	echo "No changes detected, exiting."
	popd
	exit 0
fi

# Autoformat your nix files
alejandra . &>/dev/null ||
	(
		alejandra .
		echo "formatting failed!" && exit 1
	)

# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
if sudo nixos-rebuild switch --flake ".#$1" &>.nixos-switch.log; then
	echo -e "Done\n"
else
	echo ""
	cat .nixos-switch.log | grep --color error

	# this is needed otherwise the script would not start next time telling you "no changes detected"
	# (The weird patter is to include all subdirectories)
	sudo git restore --staged ./**/*.nix

	if read -p "Open log? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
		cat .nixos-switch.log | vim -
	fi

	# Clean stuff and exit
	shopt -u globstar
	popd >/dev/null
	exit 1
fi

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!"
