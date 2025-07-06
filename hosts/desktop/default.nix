{
  config,
  pkgs,
  atmzInputs,
  ...
}:

let
  atomazu-org = pkgs.buildNpmPackage {
    pname = "atomazu-org";
    version = "1.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "atomazu";
      repo = "atomazu.org";
      rev = "6fc4bc60f79ee9efff169fd3fb84d76cb1d9d8ea";
      sha256 = "sha256-p3p8pDDzJBgASUl/mS87J4e5MhSy1PMLNqDV9EmG6dU=";
    };

    dontNpmBuild = true;
    npmDepsHash = "sha256-rkoXx1z343zj8h5L4IXktYxNlcjCRsjMBYABOcIT8QA=";

    installPhase = ''
      cp -r . $out
    '';
  };
in
{
  imports = [
    ./..
    ./hardware.nix
  ];

  ### Settings ###

  host = {
    name = "desktop";
    user = "jonas";
    locale = "en_US.UTF-8";
    extraLocale = "de_DE.UTF-8";
    layout = "us";
    extras = {
      jp.enable = true;
    };

    stylix = {
      scheme = "tomorrow-night";
    };
  };

  sys = {
    gpu.nvidia.enable = true;
    boot = {
      loader.grub = {
        enable = true;
        res = "2560x1440";
        prober = true;
      };
      silent = true;
      plymouth = true;
    };
  };

  home = {
    git = {
      enable = true;
      name = "atomazu";
      email = "contact@atomazu.org";
      signing = {
        enable = true;
        format = "ssh";
      };
    };

    chromium = {
      enable = true;
      extensions = {
        bitwarden = true;
        ublock = true;
        darkReader = true;
        sponsorBlock = true;
        yomiTan = true;
        malSync = true;
        vimium = true;
      };
    };

    shell.enable = true;
    albert.enable = true;
    nixvim.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    ashell = {
      enable = true;
      swayncIntegration = true;
    };
  };

  profiles.hyprland = {
    enable = true;
    albert = {
      enable = true;
      keybind = "$mod, R";
    };
    settings = {
      monitor = [
        "DP-2, 2560x1440@240, 1440x560, 1"
        "HDMI-A-1, 2560x1440@140, 0x0, 1, transform, 1"
      ];

      bind = [
        "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, B, exec, ${pkgs.chromium}/bin/chromium"

        # Monitor-column traversal
        "$mod CTRL, E, workspace, +1"
        "$mod CTRL, Q, workspace, -1"
        "$mod SHIFT, E, movetoworkspace, +1"
        "$mod SHIFT, Q, movetoworkspace, -1"
      ];

      workspace = [
        # DP-1: Vertical Monitor
        "1, monitor:HDMI-A-1, default:true, defaultName:1-1"
        "2, monitor:HDMI-A-1, defaultName:1-2"
        "3, monitor:HDMI-A-1, defaultName:1-3"
        "4, monitor:HDMI-A-1, defaultName:1-4"
        "5, monitor:HDMI-A-1, defaultName:1-5"

        # DP-3: Main Monitor (240Hz)
        "6, monitor:DP-2, default:true, defaultName:2-1"
        "7, monitor:DP-2, defaultName:2-2"
        "8, monitor:DP-2, defaultName:2-3"
        "9, monitor:DP-2, defaultName:2-4"
        "10, monitor:DP-2, defaultName:2-5"
      ];

      exec-once = [
        "${atmzInputs.ashell.defaultPackage.${pkgs.system}}/bin/ashell"
        "/run/current-system/sw/bin/fcitx5" # Not pkg path, needs to be in current environment
        "${pkgs.hyprland}/bin/hyprctl dispatch workspace 6" # Put mouse on main monitor at startup
      ];
    };
  };

  ### Custom Tweaks ###

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./secrets/my-secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      "TOKEN" = { };
    };

    templates = {
      "atmz-env" = {
        owner = "atmz";
        group = "atmz";
        content = ''
          TOKEN=${config.sops.placeholder.TOKEN}
          POSTS=/var/lib/api-atomazu-org/posts
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@atomazu.org";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "api.atomazu.org" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };

      "blog.atomazu.org" = {
        extraConfig = ''
          expires off;
          add_header Cache-Control "no-cache, must-revalidate";
        '';

        forceSSL = true;
        enableACME = true;

        root = atomazu-org;
      };
    };
  };

  users.groups.atmz = { };
  users.users.atmz = {
    isSystemUser = true;
    group = "atmz";
  };

  systemd.services.atmz = {
    description = "API backend for atomazu.org";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      StateDirectory = "atmz";
      User = "atmz";
      Group = "atmz";
      EnvironmentFile = config.sops.templates."atmz-env".path;
      ExecStart = "${pkgs.nodejs}/bin/node server.js";
      WorkingDirectory = "${atomazu-org}";
      Restart = "always";
      RestartSec = "5";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Fish enables this, but it's slow..
  # Investigate: There seems to be an option in fish's home manager module to disable this
  documentation.man.generateCaches = false;

  services.displayManager.gdm.autoSuspend = false;
  services.displayManager.gdm.enable = true;

  # # Steam
  # programs.steam.enable = true;
  # hardware.steam-hardware.enable = true;
  # programs.steam.extest.enable = true;
  # programs.steam.remotePlay.openFirewall = true;
  # programs.steam.localNetworkGameTransfers.openFirewall = true;
  # programs.gamescope.enable = true;
  # programs.steam.dedicatedServer.openFirewall = true;

  environment.systemPackages = with pkgs; [
    anki-bin
    mpv
    libnotify
  ];

  environment.sessionVariables = {
    "ANKI_WAYLAND" = "1";
  };

  home-manager.users.${config.host.user} = {
    # programs.vesktop.enable = true;

    services.swaync.enable = true;
    services.swaync.settings = {
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-margin-left = 8;
      control-center-width = 500;
      control-center-height = 600;
      positionX = "right";
      positionY = "bottom";
    };
  };
}
