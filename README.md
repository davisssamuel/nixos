# About

This is the NixOS configuration for my machines, both desktops and servers. As of August 2026, it primarily powers my servers, Tars and Case.

Tars and Case work in tandem: Tars acts as the main system and Case acts as the backup target and recovery host. Tars automatically takes ZFS snapshots and Case automatically backs them up using `zfs send`. This way, Tars can be recovered in an event of catastrophic failure.

# Installing the system

To install, I recommend following the NixOS Wiki for [simple NixOS ZFS on root installation
](https://wiki.nixos.org/wiki/ZFS#Simple_NixOS_ZFS_on_root_installation).

After installing NixOS, clone this repo and run:

```
nixos-rebuild switch --flake <path/to/flake>#<nixosConfigurations.name>
```

For example:

```
nixos-rebuild switch --flake .#tars
```

To setup Tars and Case, ensure the two machines are on the same network. **On Tars**, run:

```
zfs set com.sun:auto-snapshot=true <zfs_pool>
```

# Rebuilding the system

To easily rebuild the system after changes, use the bundled `nixos_rebuild.sh` script with the specific flake config you want to target. For example:

```
./nixos_rebuild.sh tars
```

Alternatively, use the standard `nixos-rebuild` command:

```
nixos-rebuild switch --flake .#tars
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

Finally, rebuild the system with the `boot` command:

```
nixos-rebuild boot --flake .#tars
```

This builds a new generation and makes it the default boot entry but does not immediately replace your running services. This is safer for major upgrades.
