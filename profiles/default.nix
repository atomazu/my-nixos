{ config, lib, ... }:

let
  cfg = config.sys;
in
{
  imports = [
    ./hyprland.nix
    ./sway.nix
  ];

  ### Options ###

  # options.profiles = {};

  ### Configuration ###

  # config = {};
}
