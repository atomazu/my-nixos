{ inputs, pkgs, ...}:

{
  imports = [
    ./../system/default.nix
    ./../profiles/default.nix
    ./../hosts/default.nix

    inputs.home-manager.nixosModules.default
  ];

  ### System Settings ###

  sys.gpu = "nvidia";
  # sys.theme = "catppuccin";
  sys.host = "desktop";
  sys.user = "jonas";
  sys.locale = "en_US.UTF-8";
  sys.layout = "us";
  sys.time = "Europe/Berlin";
  sys.boot = {
    loader = "grub";
    resolution = "1920x1080";
    prober = true;
    silent = true;
  };

  # ...

  ### Custom Configuration ###

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  programs.firefox.enable = true;

  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];
  services.xserver.xrandrHeads = [
    {
      output = "DP-0";
      monitorConfig = "Option \"Rotate\" \"left\"";
    }
    {
      output = "DP-4";
      primary = true;
    }
  ];

  environment.systemPackages = with pkgs; [
    tree
    nh # TODO: learn this properly
  ];

  # ...
}
