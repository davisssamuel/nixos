{
  description = "NixOS Homelab Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      nixosConfigurations = {
        case = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };
          modules = [ ./machines/case/configuration.nix ];
        };
      };
    };
}
