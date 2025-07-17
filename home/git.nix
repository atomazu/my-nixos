{
  config,
  lib,
  ...
}:

let
  cfg = config.atomazu.my-nixos.home;
in
{
  options.atomazu.my-nixos.home = {
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
  };

  config.home-manager.users.${config.atomazu.my-nixos.host.user} = {
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
  };
}
