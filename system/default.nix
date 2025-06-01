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
        grub = {
          res = lib.mkOption {
            type = lib.types.str;
            default = "auto";
            description = "What screen resolution Grub uses";
          };
          enable = lib.mkEnableOption "Enable grub boot";
        };
        systemd.enable = lib.mkEnableOption "Enable systemd boot";
      };

      plymouth = lib.mkEnableOption "Enable plymouth";
      prober = lib.mkEnableOption "Enable OSProber";
      silent = lib.mkEnableOption "Enable silent boot";
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
            useOSProber = cfg.boot.prober;
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
          "loglevel=3"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
          "vt.global_cursor_default=0"
        ];
      })

      {
        loader.efi.canTouchEfiVariables = true;
        loader.systemd-boot.enable = cfg.boot.loader.systemd.enable;
        plymouth.enable = cfg.boot.plymouth;
      }
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
