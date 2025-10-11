My flake-based NixOS configuration.

To easily rebuild the configuration, use the nixos-rebuild script with the flake configuration you want to target, for example:

```
./nixos-rebuild.sh tars
```

Alternatively, run the `nixos-rebuild` command directly:

```
sudo nixos-rebuild switch --flake ".#tars"
```

NOTE: changes may need to be committed before running the `nixos-rebuild` command.
