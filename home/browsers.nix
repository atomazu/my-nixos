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
  options.home = {
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

    firefox = {
      enable = lib.mkEnableOption "Firefox web browser with pre-configured extensions";
      extensions = {
        bitwarden = lib.mkEnableOption "Bitwarden password manager extension";
        uBlockOrigin = lib.mkEnableOption "uBlock Origin ad-blocker extension";
        darkReader = lib.mkEnableOption "Dark Reader for dark mode on all websites";
        sponsorBlock = lib.mkEnableOption "SponsorBlock for skipping YouTube sponsors";
        yomitan = lib.mkEnableOption "YomiTan Japanese popup dictionary";
        malSync = lib.mkEnableOption "MAL-Sync for syncing anime/manga watch history";
        vimium = lib.mkEnableOption "Vimium for Vim-like keybindings in Firefox";
        impulseBlocker = lib.mkEnableOption "Impulse Blocker for productivity";
      };
    };
  };

  config.home-manager.users.${config.host.user} = {
    programs.chromium = lib.mkIf cfg.chromium.enable {
      enable = true;

      # Enable WideVine so DRM content can be played.
      package = (pkgs.chromium.override { enableWideVine = true; });

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

    # Based on: https://github.com/Misterio77/nix-config
    programs.firefox = lib.mkIf cfg.firefox.enable {
      enable = true;
      profiles.${config.host.user} = {
        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";
          order = [
            "ddg"
            "google"
          ];
        };
        bookmarks = { };
        extensions.packages =
          with atmzInputs.firefox-addons.packages.${pkgs.system};
          lib.filter (pkg: pkg != null) (
            lib.mapAttrsToList (name: pkg: if cfg.firefox.extensions.${name} then pkg else null) {
              bitwarden = bitwarden;
              uBlockOrigin = ublock-origin;
              darkReader = darkreader;
              sponsorBlock = sponsorblock;
              yomitan = yomitan;
              malSync = mal-sync;
              vimium = vimium;
              impulseBlocker = impulse-blocker;
            }
          );
        bookmarks = { };
        settings = {
          "extensions.autoDisableScopes" = 0;
          "browser.startup.homepage" = "about:home";

          # Disable irritating first-run stuff
          "browser.disableResetPrompt" = true;
          "browser.download.panel.shown" = true;
          "browser.feeds.showFirstRunUI" = false;
          "browser.messaging-system.whatsNewPanel.enabled" = false;
          "browser.rights.3.shown" = true;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.shell.defaultBrowserCheckCount" = 1;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.uitour.enabled" = false;
          "startup.homepage_override_url" = "";
          "trailhead.firstrun.didSeeAboutWelcome" = true;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.bookmarks.addedImportButton" = true;

          # Don't ask for download dir
          "browser.download.useDownloadDir" = false;

          # Disable crappy home activity stream page
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;

          # Disable some telemetry
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # Disable fx accounts
          "identity.fxaccounts.enabled" = false;

          # Disable "save password" prompt
          "signon.rememberSignons" = false;
        };
      };
    };
  };
}
