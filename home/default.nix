{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.home;
in
{
  imports = [
    ./nixvim.nix
    ./tmux.nix
    ./vim.nix
    ./albert.nix
    ./shell.nix
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
    chromium.enable = lib.mkEnableOption "Chromium web browser";
    ashell.enable = lib.mkEnableOption "Ashell status bar";
  };

  config = {
    home-manager.users.${config.sys.user} = {
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

      programs.chromium = {
        enable = cfg.chromium.enable;

        extensions = [
          { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden Password Manager
          { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
          { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
          { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
        ];
      };

      imports = [
        ../modules/home/ashell.nix
      ];

      programs.ashell = {
        enable = cfg.ashell;
        package = inputs.ashell.defaultPackage.${pkgs.system};
        settings = {
          position = "Bottom";
          appearance = {
            style = "Solid";
          };
        };
      };

      qt.enable = true;
      gtk.enable = true;

      home.stateVersion = "24.11";
    };
  };
}
