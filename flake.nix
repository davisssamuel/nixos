{
  description = "NixOS Homelab Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };

  outputs = {self, nixpkgs, ...}: {
	
    system = "x86_64-linux";

	formatter = (system: nixpkgs.legacyPackages.${system}.nixfmt);

    nixosConfigurations = {
	  case = nixpkgs.lib.nixosSystem {
	    specialArgs = {inherit inputs outputs;};
	    modules = [./machines/case/configuration.nix];
	  };
	};
  };
}
