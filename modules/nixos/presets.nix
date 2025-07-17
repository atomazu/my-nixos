{
  lib,
  ...
}:
{
  imports = [
    ../../hosts
    ../../home
    ../../profiles
    ../../system
  ];

  options.atomazu.my-nixos.enable = lib.mkEnableOption "my-nixos configuration options";
}
