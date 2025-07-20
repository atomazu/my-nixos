{ ... }:
{
  imports = [
    ./hardware.nix
  ];

  # --- Settings ---

  atomazu.my-nixos = {
    enable = true;

    sys.boot.loader.grub.enable = true;

    host = {
      name = "server";
      user = "jonas";
      locale = "en_US.UTF-8";
      extraLocale = "de_DE.UTF-8";
      layout = "us";

      stylix.scheme = "tomorrow-night";
    };

    home = {
      git.enable = true;
      shell.enable = true;
      yazi.enable = true;
      nixvim.enable = true;
      tmux.enable = true;
    };
  };
}
