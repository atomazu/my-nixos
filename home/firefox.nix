{
  pkgs,
  config,
  lib,
  atomazu,
  ...
}:

let
  cfg = config.home.firefox;
in
{
  options.home.firefox = {
    enable = lib.mkEnableOption "Firefox web browser";
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

  # Based on: https://github.com/Misterio77/nix-config
  config.home-manager.users.${config.host.user}.programs.firefox = lib.mkIf cfg.enable {
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
        with atomazu.inputs.firefox-addons.packages.${pkgs.system};
        lib.mapAttrsToList (name: pkg: pkg) (
          lib.filterAttrs (name: pkg: cfg.extensions.${name}) {
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
}
