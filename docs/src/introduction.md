# my-nixos

Here you can find the documentation for [atomazu/my-nixos](https://github.com/atomazu/my-nixos)

To use this configuration clone the repo, add your own host and link your own `hardware.nix`.

You also have to add your host to `flake/hosts.nix` so your build command can find it.

Simple example configuration:
```nix
{
  config,
  pkgs,
  ...
}:

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

    stylix = {
      scheme = "tomorrow-night";
    };
  };

  sys = {
    boot = {
      loader.systemd.enable = true;
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
    shell.enable = true;
    nixvim.enable = true;
    tmux.enable = true;
  };

  profiles.sway.enable = true;

  ### Custom Tweaks ###
  services.nginx = {
    enable = true;
    virtualHosts."api.atomazu.org" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        proxyWebsockets = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    3000
  ];

  documentation.man.generateCaches = false;
}
```

There are various options available and I tried to make this pretty modular:

- [Host Options](https://docs.atomazu.org/host.html)
- [System Options](https://docs.atomazu.org/sys.html)
- [Profile Options](https://docs.atomazu.org/profiles.html)
- [Home Options](https://docs.atomazu.org/home.html)

