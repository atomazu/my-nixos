{
  libutils,
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
    gpu = lib.mkOption {
      type = lib.types.str;
      description = "Enable GPU specific tweaks";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The System locale";
    };

    extraLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The System locale, but extra";
    };

    layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Default keyboard layout";
    };

    time = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Berlin";
      description = "Default system time";
    };

    boot = {
      loader = {
        # Grub is enabled by default
        grub.enable = libutils.mkEnabledOption "Enable grub boot";
        systemd.enable = lib.mkEnableOption "Enable systemd boot";
      };

      resolution = lib.mkOption {
        type = lib.types.str;
        default = "auto";
        description = "What screen resolution Grub uses";
      };

      plymouth = lib.mkEnableOption "Enable plymouth";
      prober = lib.mkEnableOption "Enable OSProber";
      silent = lib.mkEnableOption "Enable silent boot";
    };
  };

  config = {
    boot =
      let
        systemdBootCfg = lib.mkIf cfg.boot.loader.systemd.enable {
          loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
          };
        };

        grubCfg = lib.mkIf cfg.boot.loader.grub.enable {
          loader = {
            efi.canTouchEfiVariables = true;
            efi.efiSysMountPoint = "/boot";
            grub =
              {
                enable = true;
                efiSupport = true;
                device = "nodev";
                useOSProber = cfg.boot.prober;
              }
              // lib.mkIf (cfg.boot.resolution != "auto") {
                gfxmodeEfi = cfg.boot.resolution;
              };
          };
        };

        silentBootCfg = lib.mkIf cfg.boot.silent {
          consoleLogLevel = 0;
          initrd.verbose = false;
          kernelParams = [
            "quiet"
            "splash"
            "boot.shell_on_fail"
            "loglevel=3"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "udev.log_priority=3"
            "vt.global_cursor_default=0"
          ];
        };

        plymouthCfg = {
          plymouth.enable = cfg.boot.plymouth;
        };

      in
      lib.mkMerge [
        systemdBootCfg
        grubCfg
        silentBootCfg
        plymouthCfg
      ];

    networking.hostName = "${config.host.name}";
    networking.networkmanager.enable = true;

    time.timeZone = "${cfg.time}";
    time.hardwareClockInLocalTime = true;
    i18n.defaultLocale = "${cfg.locale}";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "${cfg.extraLocale}";
      LC_IDENTIFICATION = "${cfg.extraLocale}";
      LC_MEASUREMENT = "${cfg.extraLocale}";
      LC_MONETARY = "${cfg.extraLocale}";
      LC_NAME = "${cfg.extraLocale}";
      LC_NUMERIC = "${cfg.extraLocale}";
      LC_PAPER = "${cfg.extraLocale}";
      LC_TELEPHONE = "${cfg.extraLocale}";
      LC_TIME = "${cfg.extraLocale}";
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.xserver.xkb.layout = cfg.layout;
    services.openssh.enable = true;
  };
}
