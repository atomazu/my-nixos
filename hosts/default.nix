{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.sys;
in
{
  imports = [
    ./../system/default.nix
    ./../home/default.nix
    ./../profiles/default.nix
  ];

  ### Options ###

  options.sys = {
    host = lib.mkOption {
      type = lib.types.str;
      default = "host";
      description = "The hostname of the system";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "user";
      description = "The primary user of the system";
    };

    nh = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "If nh should be enabled";
    };

    gpu = lib.mkOption {
      type = lib.types.str;
      default = "";
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
      loader = lib.mkOption {
        type = lib.types.str;
        default = "grub";
        description = "Specify boot loader (grub/systemd)";
      };

      plymouth = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Plymouth boot splash screen.";
      };

      resolution = lib.mkOption {
        type = lib.types.str;
        default = "none";
        description = "What screen resolution Grub uses";
      };

      prober = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "If OSProber should be executed on rebuild";
      };

      silent = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable silent boot";
      };
    };
  };

  ### Configuration ###

  config = {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    boot = lib.mkMerge [
      (lib.mkIf (cfg.boot.loader == "systemd") {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      })
      (lib.mkIf (cfg.boot.loader == "grub") {
        loader = {
          efi.canTouchEfiVariables = true;
          efi.efiSysMountPoint = "/boot";
          grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
            useOSProber = cfg.boot.prober;
          };
        };
      })
      (lib.mkIf (cfg.boot.resolution != "none") {
        loader.grub.gfxmodeEfi = cfg.boot.resolution;
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
      (lib.mkIf cfg.boot.plymouth {
        plymouth.enable = true;
      })
    ];

    networking.hostName = "${cfg.host}";
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

    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
    ];

    services.xserver.xkb.layout = cfg.layout;
    services.openssh.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # security.pam.loginLimits = [
    #   {
    #     domain = "@users";
    #     item = "rtprio";
    #     type = "-";
    #     value = 1;
    #   }
    # ];

    users.users.${cfg.user} = {
      isNormalUser = true;
      description = "${cfg.user}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
      ];
    };

    programs.nh = {
      enable = cfg.nh;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = ./..;
    };

    environment.sessionVariables = {
      FLAKE = ./..;
    };

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    system.stateVersion = "24.11";
  };
}
