{ config, lib, ... }:

let
  cfg = config.sys;
in
{
  imports = [
    ./hyprland.nix
  ];

  ### Options ###

  # options.profiles = {};

  ### Configuration ###

  # config = {};
}
