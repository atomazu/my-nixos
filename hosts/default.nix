{ inputs, config, pkgs, lib, ... }:

let
  cfg = config.sys;
in
{
  imports = [
    ./../system/default.nix
    ./../profiles/default.nix
    ./desktop-hardware.nix 
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

    theme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin";
      description = "The overall system theme";
    };

    gpu = lib.mkOption {
      type = lib.types.str;
      default = "nvidia";
      description = "Enable GPU specific tweaks";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The System locale";
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

      plymouth.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Plymouth to make booting fancy";
      };

      resolution = lib.mkOption {
        type = lib.types.str;
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
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
          grub.gfxmodeEfi = cfg.boot.resolution;
          grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";  
            useOSProber = cfg.boot.prober;
          };
        };
      })
      (lib.mkIf cfg.boot.plymouth.enable {
        loader.timeout = 0;
        plymouth = {
          enable = true;
          theme = "rings";
          themePackages = with pkgs; [
            (adi1090x-plymouth-themes.override {
              selected_themes = ["rings"];
            })
          ];
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
        ];
      })
    ];

    networking.hostName = "${cfg.host}"; 
    networking.networkmanager.enable = true;

    time.timeZone = "${cfg.time}";
    time.hardwareClockInLocalTime = true;
    i18n.defaultLocale = "${cfg.locale}";

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

    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        type = "-";
        value = 1;
      }
    ];

    users.users.${cfg.user} = {
      isNormalUser = true;
      description = "A user account.";
      extraGroups = [ "networkmanager" "wheel" "video" ];
    };

    ### Home Manager ###

    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${cfg.user} = {
        imports = [
          ./../home/default.nix
        ];
      };
    };

    services.xserver.enable = true;

    system.stateVersion = "24.11";
  };
}
