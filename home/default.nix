{
  config,
  lib,
  atmzInputs,
  ...
}:

let
  cfg = config.home;
in
{
  imports = [
    atmzInputs.home-manager.nixosModules.default
    ./tmux.nix
    ./vim.nix
    ./albert.nix
    ./shell.nix
    ./ashell.nix
    ./yazi.nix
  ];

  options.home = {
    git = {
      enable = lib.mkEnableOption "Git version control";
      name = lib.mkOption {
        type = lib.types.str;
        example = "John Doe";
        description = "Git name";
      };
      email = lib.mkOption {
        type = lib.types.str;
        example = "example@mail.com";
        description = "Git email";
      };
      signing = {
        enable = lib.mkEnableOption "Git commit signing";
        format = lib.mkOption {
          type = lib.types.enum [
            "ssh"
            "gpg"
          ];
          example = "ssh";
          description = "Signing format (ssh or gpg)";
        };
        key = lib.mkOption {
          type = lib.types.str;
          default = "~/.ssh/id_ed25519.pub";
          description = "Path to signing key";
        };
      };
    };
    chromium = {
      enable = lib.mkEnableOption "Chromium web browser";
      extensions = {
        bitwarden = lib.mkEnableOption "Bitwarden Password Manager";
        ublock = lib.mkEnableOption "uBlock Origin Lite";
        darkReader = lib.mkEnableOption "Dark Reader";
        sponsorBlock = lib.mkEnableOption "SponsorBlock";
        yomiTan = lib.mkEnableOption "YomiTan Popup Dictionary";
        malSync = lib.mkEnableOption "MAL-Sync";
        vimium = lib.mkEnableOption "Vimium";
      };
    };
    nixvim.enable = lib.mkEnableOption "Enable Nixvim";
  };

  config = {
    home-manager = {
      extraSpecialArgs = { inherit atmzInputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    home-manager.users.${config.host.user} = {
      imports = [
        ../modules/home
      ];

      atomazu.nixvim.enable = cfg.nixvim.enable;

      programs.git = {
        enable = cfg.git.enable;
        userName = "${cfg.git.name}";
        userEmail = "${cfg.git.email}";
        signing = lib.mkIf cfg.git.signing.enable {
          key = cfg.git.signing.key;
          signByDefault = true;
        };
        extraConfig = lib.mkIf cfg.git.signing.enable {
          gpg.format = cfg.git.signing.format;
          commit.gpgsign = true;
          tag.gpgsign = true;
        };
      };

      programs.chromium = lib.mkIf cfg.chromium.enable {
        enable = true;

        extensions = lib.mapAttrsToList (name: id: { inherit id; }) (
          lib.filterAttrs (name: id: cfg.chromium.extensions.${name}) {
            bitwarden = "nngceckbapebfimnlniiiahkandclblb";
            ublock = "ddkjiahejlhfcafbddmgiahcphecmpfh";
            darkReader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            sponsorBlock = "mnjggcdmjocbbbhaepdhchncahnbgone";
            yomiTan = "likgccmbimhjbgkjambclfkhldnlhbnn";
            malSync = "kekjfbackdeiabghhcdklcdoekaanoel";
            vimium = "dbepggeogbaibhgnhhndojpepiihcmeb";
          }
        );
      };

      home.stateVersion = "25.05";
    };
  };
}
