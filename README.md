My flake-based NixOS configuration.

To easily rebuild the config, use the bundled nixos-rebuild script with the specific flake config you want to target, for example:

```
./nixos-rebuild.sh tars
```

If there are no changes and you just want to rebuild your system using this config, run the `nixos-rebuild` command directly:

```
sudo nixos-rebuild switch --flake ".#tars"
```
