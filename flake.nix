{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      vars = import ./vars.nix;
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = {
        case = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit vars; };
          modules = [ ./machines/case/configuration.nix ];
        };
      };
    };
}
