{ inputs, pkgs, lib, ... }:

{
  imports = [
    ./../hosts/default.nix
    # ./hardware-template.nix # Add hardware config import here

    inputs.home-manager.nixosModules.default
  ];

  sys.host = "template-host";
  sys.user = "template-user";
  # Add other sys options here

  # Enable desired profiles here
  # profiles.example.enable = true;

  # Override home options if needed
  # home.example.enable = false;

  # Enable system modules if needed
  # system.example.enable = true;

  system.stateVersion = "24.11"; # Or your current version
}