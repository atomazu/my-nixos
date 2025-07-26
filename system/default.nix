{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.atomazu.my-nixos.sys;
in
{
  imports = [
    ./nvidia.nix
  ];

  options.atomazu.my-nixos.sys = {
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

    displayManager = {
      gdm.enable = lib.mkEnableOption "GNOME Display Manager";
      regreet = {
        enable = lib.mkEnableOption "A clean and customizable GTK-based greetd greeter written in Rust";
      };
    };
  };

  config = lib.mkIf config.atomazu.my-nixos.enable {
    programs.regreet.enable = cfg.displayManager.regreet.enable;
    services.greetd = lib.mkIf cfg.displayManager.regreet.enable {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.cage}/bin/cage -s -mlast -- ${pkgs.greetd.regreet}/bin/regreet";
        };
      };
    };

    services.displayManager.gdm.enable = cfg.displayManager.gdm.enable;
    services.displayManager.gdm.autoSuspend = false;

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
          "vt.global_cursor_default=0"
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

    networking.hostName = "${config.atomazu.my-nixos.host.name}";
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    services.openssh.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
