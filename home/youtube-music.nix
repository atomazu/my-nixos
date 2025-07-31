{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.atomazu.my-nixos.home.youtube-music;
  colors = config.lib.stylix.colors.withHashtag;
  fonts = config.stylix.fonts;

  theme = pkgs.writeText "youtube-music-theme.css" ''
    /* --- Base Variables --- */
    html:not(.style-scope) {
      --ytmusic-color-black1: ${colors.base01} !important;
      --ytmusic-color-black4: ${colors.base00} !important;
      --ytmusic-dialog-background-color: ${colors.base00} !important;

      --ytmusic-color-grey1: ${colors.base06} !important;
      --ytmusic-color-grey2: ${colors.base05} !important;
      --ytmusic-color-grey3: ${colors.base03} !important;
      --ytmusic-color-grey4: ${colors.base04} !important;
      --ytmusic-color-grey5: ${colors.base05} !important;

      --ytmusic-color-white1: ${colors.base07} !important;
      --ytmusic-color-white1-alpha70: ${colors.base05} !important;
      --ytmusic-color-white1-alpha50: ${colors.base04} !important;
      --ytmusic-color-white1-alpha30: ${colors.base03} !important;
      --ytmusic-color-white1-alpha20: ${colors.base02} !important;
      --ytmusic-color-white1-alpha15: ${colors.base02} !important;
      --ytmusic-color-white1-alpha10: ${colors.base01} !important;

      --ytmusic-static-brand-red: ${colors.base08} !important;
      --yt-spec-themed-blue: ${colors.base0D} !important;
      --yt-spec-dark-blue: ${colors.base0D} !important;
      --ytmusic-setting-item-toggle-active: ${colors.base0B} !important;
      --yt-spec-brand-link-text: ${colors.base0D} !important;

      --yt-spec-text-secondary: ${colors.base05} !important;
      --ytmusic-caption-1_-_color: ${colors.base04} !important;

      --ytmusic-scrollbar-width: 0px !important;
      --ytd-scrollbar-width: 0px !important;
      --ytd-scrollbar-scrubber_-_background: ${colors.base00};

      /* Unset Variables */
      --idk-yet: inherit !important;
      --ytmusic-color-blackpure: var(--idk-yet) !important;
      --ytmusic-color-blackpure-alpha0: var(--idk-yet) !important;
      --ytmusic-color-blackpure-alpha10: var(--idk-yet) !important;
      --ytmusic-color-blackpure-alpha60: var(--idk-yet) !important;
      --ytmusic-brand-link-text: var(--idk-yet) !important;
      --ytmusic-overlay-background-brand: var(--idk-yet) !important;
      --ytmusic-focus-active: var(--idk-yet) !important;
      --ytmusic-detail-header: var(--idk-yet) !important;
    }

    /* --- General & Backgrounds --- */
    body,
    ytmusic-nav-bar,
    ytmusic-player-bar,
    ytmusic-player-page,
    ytmusic-data-bound-header-renderer,
    ytmusic-list-item-renderer,
    ytmusic-responsive-list-item-renderer,
    ytmusic-player-queue-item {
      background: ${colors.base00} !important;
    }

    div.background-gradient.style-scope.ytmusic-browse-response {
      background-image: linear-gradient(to bottom, ${colors.base00}, ${colors.base00}) !important;
    }

    /* --- Icons --- */
    i.material-icons { color: ${colors.base05} !important; }
    i.material-icons:hover { color: ${colors.base07} !important; }

    paper-icon-button#play-pause-button,
    tp-yt-iron-icon#icon {
      --iron-icon-fill-color: ${colors.base0A} !important;
    }

    paper-icon-button {
      --paper-icon-button_-_color: var(--ytmusic-color-white1) !important;
    }

    paper-icon-button.ytmusic-like-button-renderer { color: ${colors.base08} !important; }
    yt-icon.ytmusic-inline-badge-renderer { color: ${colors.base0E} !important; }
    .style-scope.yt-icon-button[aria-label="Add to playlist"] { color: ${colors.base0B} !important; }

    /* --- Header & Nav --- */
    .yt-simple-endpoint[aria-label="Home"] { visibility: hidden !important; }

    ytmusic-pivot-bar-item-renderer { color: ${colors.base05} !important; }
    ytmusic-pivot-bar-item-renderer:hover,
    ytmusic-pivot-bar-item-renderer.iron-selected { color: ${colors.base07} !important; }

    ytmusic-search-box { color: ${colors.base05} !important; }
    .title.ytmusic-header-renderer { color: ${colors.base06} !important; }
    .title.ytmusic-detail-header-renderer { color: ${colors.base07} !important; }

    .title.ytmusic-carousel-shelf-basic-header-renderer,
    .title.ytmusic-immersive-header-renderer,
    .description.ytmusic-immersive-header-renderer {
      color: ${colors.base07} !important;
    }

    yt-formatted-string.strapline.text.style-scope.ytmusic-carousel-shelf-basic-header-renderer {
      color: ${colors.base04} !important;
    }

    /* --- Player & Progress Bar --- */
    #progress-bar.ytmusic-player-bar {
      --paper-slider-active-color: var(--ytmusic-color-white1) !important;
    }
    #progress-bar.ytmusic-player-bar[focused],
    ytmusic-player-bar:hover #progress-bar.ytmusic-player-bar {
      --paper-slider-knob-color: var(--ytmusic-color-white1) !important;
      --paper-slider-knob-start-color: var(--ytmusic-color-white1) !important;
      --paper-slider-knob-start-border-color: var(--ytmusic-color-white1) !important;
    }

    paper-slider#volume-slider,
    .volume-slider.ytmusic-player-bar,
    .expand-volume-slider.ytmusic-player-bar {
      --paper-slider-container-color: ${colors.base03} !important;
      --paper-slider-active-color: ${colors.base0D} !important;
      --paper-slider-knob-color: ${colors.base0D} !important;
    }

    .left-controls.ytmusic-player-bar paper-icon-button.ytmusic-player-bar,
    .left-controls.ytmusic-player-bar .spinner-container.ytmusic-player-bar,
    .toggle-player-page-button.ytmusic-player-bar,
    .menu.ytmusic-player-bar,
    .right-controls-buttons.ytmusic-player-bar paper-icon-button.ytmusic-player-bar,
    ytmusic-player-expanding-menu.ytmusic-player-bar paper-icon-button.ytmusic-player-bar {
      --iron-icon-fill-color: ${colors.base05} !important;
      --paper-icon-button_-_color: ${colors.base05} !important;
    }

    /* --- Tabs & Queue --- */
    tp-yt-paper-tab.ytmusic-player-page { color: ${colors.base05} !important; }
    paper-tab.iron-selected.ytmusic-player-page,
    tp-yt-paper-tab.iron-selected.ytmusic-player-page { color: ${colors.base0A} !important; }

    paper-tabs.ytmusic-player-page { --paper-tabs-selection-bar-color: ${colors.base0A} !important; }
    #selectionBar.tp-yt-paper-tabs { border-bottom: 2px solid ${colors.base0A} !important; }

    yt-formatted-string.byline.style-scope.ytmusic-player-queue-item { color: ${colors.base04} !important; }
    yt-formatted-string.duration.style-scope.ytmusic-player-queue-item { color: ${colors.base03} !important; }

    /* --- Buttons & Links --- */
    a.ytmusic-content-update-chip {
      color: ${colors.base00} !important;
      background-color: ${colors.base0A} !important;
    }

    .content-wrapper.ytmusic-play-button-renderer,
    ytmusic-play-button-renderer:hover .content-wrapper.ytmusic-play-button-renderer,
    ytmusic-play-button-renderer:focus .content-wrapper.ytmusic-play-button-renderer {
      background: var(--ytmusic-color-white1-alpha70) !important;
      --ytmusic-play-button-icon-color: var(--ytmusic-color-black1) !important;
      --paper-spinner-color: var(--yt-spec-themed-blue) !important;
    }

    yt-button-renderer[is-paper-button] {
      background-color: var(--ytmusic-color-white1-alpha70) !important;
    }

    yt-button-renderer.watch-button.ytmusic-menu-renderer {
      color: var(--ytmusic-color-white1) !important;
      background-color: var(--ytmusic-color-white1-alpha70) !important;
    }

    ytmusic-data-bound-top-level-menu-item.ytmusic-data-bound-menu-renderer:not(:first-child) {
      --yt-button-color: var(--ytmusic-color-white1) !important;
      border: 1px solid var(--ytmusic-color-white1) !important;
      border-radius: 5px !important;
    }

    #top-level-buttons.ytmusic-menu-renderer > .outline-button.ytmusic-menu-renderer,
    .edit-playlist-button.ytmusic-menu-renderer,
    ytmusic-toggle-button-renderer.ytmusic-menu-renderer {
      --yt-button-color: var(--ytmusic-color-white1) !important;
    }

    ytmusic-subscribe-button-renderer {
      --ytmusic-subscribe-button-color: ${colors.base0B} !important;
    }

    .previous-items-button.ytmusic-carousel,
    .next-items-button.ytmusic-carousel {
      background-color: var(--ytmusic-color-white1-alpha70) !important;
      color: var(--ytmusic-color-black1) !important;
    }

    yt-formatted-string[has-link-only_]:not([force-default-style]) a.yt-simple-endpoint.yt-formatted-string {
      color: ${colors.base0D} !important;
    }
    yt-formatted-string[has-link-only_]:not([force-default-style]) a.yt-simple-endpoint.yt-formatted-string:hover {
      color: ${colors.base0C} !important;
    }

    /* --- Miscellaneous --- */
    .category-menu-item.iron-selected.ytmusic-settings-page {
      background-color: ${colors.base02} !important;
    }
    .dropdown-content {
      background-color: ${colors.base01} !important;
    }

    * { font-family: ${fonts.sansSerif.name} !important; }
  '';

  settings = {
    options = {
      tray = true;
      appVisible = true;
      autoUpdates = true;
      alwaysOnTop = false;
      hideMenu = true;
      hideMenuWarned = true;
      startAtLogin = false;
      disableHardwareAcceleration = false;
      removeUpgradeButton = false;
      restartOnConfigChanges = false;
      trayClickPlayPause = false;
      autoResetAppCache = false;
      resumeOnStart = false;
      likeButtons = "";
      proxy = "";
      startingPage = "";
      overrideUserAgent = false;
      usePodcastParticipantAsArtist = false;
      themes = [ "${if cfg.themeFile != null then cfg.themeFile else theme}" ];
      language = "en";
    };

    plugins = {
      notifications = {
        enabled = true;
        unpauseNotification = false;
        urgency = "low";
        interactive = true;
        toastStyle = 1;
        refreshOnPlayPause = false;
        trayControls = true;
        hideButtonText = false;
      };
      video-toggle = {
        mode = "custom";
      };
      precise-volume = {
        globalShortcuts = { };
      };
      discord = {
        listenAlong = true;
        enabled = true;
        autoReconnect = true;
        activityTimeoutEnabled = true;
        activityTimeoutTime = 5000;
        playOnYouTubeMusic = true;
        hideGitHubButton = false;
        hideDurationLeft = false;
      };
      ambient-mode = {
        enabled = true;
        quality = 50;
        buffer = 30;
        interpolationTime = 1500;
        blur = 500;
        size = 100;
        opacity = 1;
        fullscreen = false;
      };
      blur-nav-bar = {
        enabled = true;
      };
      in-app-menu = {
        enabled = false;
      };
    };

    __internal__ = {
      migrations = {
        version = "3.9.0";
      };
    };
  };
in
{
  options.atomazu.my-nixos.home.youtube-music = {
    enable = lib.mkEnableOption "YouTube Music with opinionated defaults";

    themeFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to custom theme CSS file. If null, uses generated stylix theme.";
      example = lib.literalExpression ''./themes/custom-youtube-music.css'';
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra settings that will be recursively merged with the default configuration";
      example = lib.literalExpression ''
        {
          options.startAtLogin = true;
          plugins.discord.enabled = false;
          plugins.notifications.urgency = "normal";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.atomazu.my-nixos.host.user} = {
      atomazu.youtube-music = {
        enable = true;
        settings = lib.recursiveUpdate settings cfg.extraSettings;
      };
    };
  };
}
