{ config, lib, ... }:

lib.mkIf (config.sys.gpu == "nvidia") {
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  hardware = {
    graphics = {
      enable = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;

      open = false;
      nvidiaSettings = false;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
