{
  inputs,
  config,
  lib,
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
        default = "John Doe";
        description = "Git name";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "example@mail.com";
        description = "Git email";
      };
    };
    chromium.enable = lib.mkEnableOption "Chromium web browser";
  };

  config = {
    home-manager.users.${config.sys.user} = {
      programs.git = {
        enable = cfg.git.enable;
        userName = "${cfg.git.name}";
        userEmail = "${cfg.git.email}";
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

      qt.enable = true;
      gtk.enable = true;

      home.stateVersion = "24.11";
    };
  };
}
