{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.quickshell;
in {
  options.modules.desktop.apps.quickshell = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Quickshell and its required dependencies.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      quickshell
      brightnessctl
      playerctl
      pamixer
      networkmanager
      bluez
      bluez-utils
      cliphist
      wl-clipboard
      imagemagick
      jq
      dotool
      kde-cli-tools
      
      # Fonts & Themes
      inter
      papirus-icon-theme
      bibata-cursor-theme
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];

    home.configFile."quickshell" = {
      source = ../../../config/quickshell;
      recursive = true;
    };
  };
}
