{ config, lib, ... }:

let
  cfg = config.sys;
in
{
  imports = [
    ./hyprland.nix
    ./sway.nix
    ./gnome.nix
    ./cinnamon.nix
  ];

  ### Options ###

  # options.profiles = {};

  ### Configuration ###

  # config = {};
}
