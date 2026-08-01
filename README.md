To easily rebuild the system, use the bundled `nixos-rebuild.sh` script with the specific flake config you want to target. For example:

```
./nixos-rebuild.sh tars
```

Optionally, use the standard `nixos-rebuild` command:

```
sudo nixos-rebuild switch --flake ".#tars"
```
