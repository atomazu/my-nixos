{
  pkgs,
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
      enable = lib.mkEnableOption "Git source control integration";
      name = lib.mkOption {
        type = lib.types.str;
        example = "John Doe";
        description = "Full name for Git commits";
      };
      email = lib.mkOption {
        type = lib.types.str;
        example = "example@mail.com";
        description = "Email address for Git commits";
      };
      signing = {
        enable = lib.mkEnableOption "Git commit signing with a GPG or SSH key";
        format = lib.mkOption {
          type = lib.types.enum [
            "ssh"
            "gpg"
          ];
          example = "ssh";
          description = "Key format for commit signing (ssh or gpg)";
        };
        key = lib.mkOption {
          type = lib.types.str;
          default = "~/.ssh/id_ed25519.pub";
          description = "Public key or key ID for commit signing";
        };
      };
    };
    chromium = {
      enable = lib.mkEnableOption "Chromium web browser with pre-configured extensions";
      extensions = {
        bitwarden = lib.mkEnableOption "Bitwarden password manager extension";
        uBlockLite = lib.mkEnableOption "uBlock Origin ad-blocker extension";
        darkReader = lib.mkEnableOption "Dark Reader for dark mode on all websites";
        sponsorBlock = lib.mkEnableOption "SponsorBlock for skipping YouTube sponsors";
        yomitan = lib.mkEnableOption "YomiTan Japanese popup dictionary";
        malSync = lib.mkEnableOption "MAL-Sync for syncing anime/manga watch history";
        vimium = lib.mkEnableOption "Vimium for Vim-like keybindings in Chromium";
        websiteBlocker = lib.mkEnableOption "Website blocker for productivity";
      };
    };
    nixvim.enable = lib.mkEnableOption "Nix-managed Neovim configuration";
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
            uBlockLite = "ddkjiahejlhfcafbddmgiahcphecmpfh";
            darkReader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            sponsorBlock = "mnjggcdmjocbbbhaepdhchncahnbgone";
            yomitan = "likgccmbimhjbgkjambclfkhldnlhbnn";
            malSync = "kekjfbackdeiabghhcdklcdoekaanoel";
            vimium = "dbepggeogbaibhgnhhndojpepiihcmeb";
            websiteBlocker = "aoabjfoanlljmgnohepbkimcekolejjn";
          }
        );
      };

      home.stateVersion = "25.05";
    };
  };
}
