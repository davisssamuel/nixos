# Rebuilding the system

To easily rebuild the system, use the bundled `nixos-rebuild.sh` script with the specific flake config you want to target. For example:

```
./nixos-rebuild.sh tars
```

Alternatively, use the standard `nixos-rebuild` command:

```
sudo nixos-rebuild switch --flake ".#tars"
```

# Updating NixOS

To update NixOS to a newer release (e.g. 25.11 -> 26.05), first update nixpkgs in `flake.nix`:

```nix
inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11"; # <- update this to 26.05
};
```

Then update the flake:

```
nix flake update
```

Verify the `flake.lock` file was updated:

```
git diff flake.lock
```

Finally, rebuild the system with the `boot` command. This builds a new generation and makes it the default boot entry but does not immediately replace your running services. This is safer for major upgrades.

```
sudo nixos-rebuild boot --flake .#tars
```
