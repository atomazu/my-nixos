{
  lib,
  config,
  ...
}:

let
  cfg = config.sys;
in
{
  imports = [
    ./nvidia.nix
  ];

  options.sys = {
    gpu = {
      nvidia = {
        enable = lib.mkEnableOption "Nvidia GPU support and optimizations";
        beta = lib.mkEnableOption "Beta Nvidia drivers with latest features";
      };
    };

    boot = {
      loader = {
        grub = {
          res = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "What screen resolution Grub uses";
          };
          enable = lib.mkEnableOption "GRUB bootloader for system startup";
          prober = lib.mkEnableOption "OS detection and multi-boot menu generation";
        };
        systemd.enable = lib.mkEnableOption "Systemd-boot as the system bootloader";
      };
      plymouth = lib.mkEnableOption "Plymouth boot splash screen manager";
      silent = lib.mkEnableOption "Silent boot with suppressed kernel messages";
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.boot.loader.grub.enable && cfg.boot.loader.systemd.enable);
        message = "Both systemd and grub enabled, choose either but not both";
      }
      {
        assertion = cfg.boot.loader.grub.enable || cfg.boot.loader.systemd.enable;
        message = "No bootloader configured, enable sys.boot.loader.grub.enable or sys.boot.loader.systemd.enable";
      }
    ];

    boot = lib.mkMerge [
      (lib.mkIf cfg.boot.loader.grub.enable {
        loader = {
          efi.efiSysMountPoint = "/boot";
          grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            useOSProber = cfg.boot.loader.grub.prober;
            gfxmodeEfi = lib.mkIf (cfg.boot.loader.grub.res != "auto") cfg.boot.loader.grub.res;
          };
        };
      })

      (lib.mkIf cfg.boot.silent {
        consoleLogLevel = 0;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "loglevel=0"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
          "systemd.show_status=false"
          "fbcon=nodefer"
        ];
      })

      {
        loader.efi.canTouchEfiVariables = true;
        loader.systemd-boot.enable = cfg.boot.loader.systemd.enable;
        plymouth.enable = cfg.boot.plymouth;
      }
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    networking.hostName = "${config.host.name}";
    networking.networkmanager.enable = true;

    services.gnome.gnome-keyring.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    services.openssh.enable = true;
  };
}
