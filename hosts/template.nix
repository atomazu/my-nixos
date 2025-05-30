{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  ### Settings ###

  sys = {
    # ...
  };

  home = {
    # ...
  };

  profiles = {
    # ...
  };

  ### Tweaks ###

  environment.systemPackages = with pkgs; [
    tree
    # ...
  ];

  home-manager.users.${config.host.user} = {
    # ...
  };

  system.stateVersion = "24.11"; # Or your current version
}
