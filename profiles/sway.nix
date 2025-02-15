{ pkgs, ... }:

{
  imports = [
    ./waybar.nix
  ];
  
  programs.wpaperd = {
    enable = true;
    settings = {
      default = {
        path = "~/.nixos/assets/wallpaper.jpg";
      };
    };
  };

  services.mako.enable = true;
  programs.tofi = {
    enable = true;
    settings = {
      anchor = "top";
      width = "100%";
      height = 24;
      horizontal = true;
      font-size = 12;
      prompt-text = " run: ";
      font = "monospace";
      outline-width = 0;
      border-width = 0;
      min-input-width = 120;
      result-spacing = 15;
      padding-top = 0;
      padding-bottom = 0;
      padding-left = 0;
      padding-right = 0;
    };
  };

  wayland.windowManager.sway = {
    enable = true;

    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    xwayland = true;
    # package = pkgs.swayfx; 

    config = {
      menu = "${pkgs.tofi}/bin/tofi-run | xargs swaymsg exec --";
      terminal = "${pkgs.foot}/bin/foot";
      modifier = "Mod4";
      window.titlebar = false;

      bars = [{
        command = "${pkgs.waybar}/bin/waybar"; 
      }];

      startup = [{
        command = "${pkgs.wpaperd}/bin/wpaperd"; 
      }];

      floating = {
        criteria = [
          { class = "pavucontrol"; }
        ];
      };
    };
  };
}
