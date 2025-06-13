{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/sam/nixos/config.nix
    ];
  system.stateVersion = "25.05"; # Did you read the comment?
}

