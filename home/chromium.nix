{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.atomazu.my-nixos.home.chromium;
in
{
  options.atomazu.my-nixos.home.chromium = {
    enable = lib.mkEnableOption "Chromium web browser";
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

    widevine = lib.mkEnableOption "WideVine binaries for playing DRM-protected content";
    package = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = pkgs.chromium.override { enableWideVine = cfg.widevine; };
      description = "The package to use";
    };
  };

  config.home-manager.users.${config.atomazu.my-nixos.host.user}.programs.chromium = lib.mkIf cfg.enable {
    enable = true;
    package = cfg.package;
    extensions = lib.mapAttrsToList (name: id: { inherit id; }) (
      lib.filterAttrs (name: id: cfg.extensions.${name}) {
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
}
