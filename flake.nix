{
  description = "NixOS Homelab Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };

  outputs = {self, nixpkgs, ...}: 
  let
    system = "x86_64-linux";
  in {
	formatter = (system: nixpkgs.legacyPackages.${system}.nixfmt);

    nixosConfigurations = {
	  case = nixpkgs.lib.nixosSystem {
	    specialArgs = {inherit system;};
	    modules = [./machines/case/configuration.nix];
	  };
	};
  };
}
