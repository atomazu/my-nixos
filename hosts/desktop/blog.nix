{
  atomazu,
  config,
  pkgs,
  ...
}:

let
  atomazu-org = pkgs.buildNpmPackage {
    pname = "atomazu-org";
    version = "1.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "atomazu";
      repo = "atomazu.org";
      rev = "b8b1030ee36292e9585c3aa058359d4dbe1877e7";
      sha256 = "sha256-hyC2uqvWihGDKOoZB1q7pdxTBJEDWyTgmEe1wWoFofQ=";
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
    atomazu.inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ./secrets/my-secrets.yaml;
    defaultSopsFormat = "yaml";

    secrets = {
      TOKEN = { };
    };

    templates = {
      "atmz-env" = {
        owner = "atmz";
        group = "atmz";
        content = ''
          TOKEN=${config.sops.placeholder.TOKEN}
          POSTS=/var/lib/atmz
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
}
