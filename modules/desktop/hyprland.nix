{
  hey,
  heyBin,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.hyprland;
  primaryMonitor = findFirst (x: x.primary) {} cfg.monitors;
in {
  options.modules.desktop.hyprland = with types; {
    enable = mkBoolOpt false;
    extraConfig = mkOpt lines "";
    monitors = mkOpt (listOf (submodule {
      options = {
        output = mkOpt str "";
        mode = mkOpt str "preferred";
        position = mkOpt str "auto";
        scale = mkOpt int 1;
        disable = mkOpt bool false;
        primary = mkOpt bool false;
      };
    })) [{}];
  };

  config = mkIf cfg.enable {
    modules.desktop.enable = true;

    environment.systemPackages = with pkgs; [
      ## Essential Hyprland & Display utilities
      xrandr
      gromit-mpx
      wlr-randr
      wf-recorder

      ## Ricelin Dependencies
      quickshell
      matugen
      cliphist
      wl-clipboard
      imagemagick
      jq
      brightnessctl
      playerctl
      hyprpicker
      hyprpolkitagent
      hypridle
      dotool
      pamixer
      #kde-cli-tools
      fastfetch
      # Note: 'awww' (animated wallpaper daemon) is required by Ricelin.
      # If it is not present in nixpkgs, it must be added via an overlay or flake input.
    ];

    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
      systemd.setPath.enable = true;
    };

    # Note: programs.dms-shell has been removed to prevent conflict with Ricelin

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "uwsm start -eD Hyprland hyprland.desktop";
        user = config.user.name;
      };
    };

    hey = {
      info = {
        hypr = {
          primaryMonitor = primaryMonitor.output or null;
          monitors = cfg.monitors;
        };
        theme.fonts = {
          mono = "JetBrainsMono Nerd Font";
          sans = "Fira Sans";
        };
      };
      hooks = rec {
        startup."05-startup-sound" = ''
          hey .play-sound startup
        '';
        reload."95-hyprland" = ''
          for i in $(hyprctl instances -j | jq -r '.[].instance'); do
            echo "Hyprland: reloading instance $i"
            hey.do hyprctl -i ''${i//*\//} reload config-only
          done
        '';
      };
    };

    home.configFile = {
      "matugen/templates".source = "${hey.configDir}/matugen/templates";
      "matugen/config.toml".text = ''
        [config]
        version_check = false
        import_json_files = ["${config.home.dataDir}/hey/info.json"]

        [templates.hyprland]
        input_path = "${hey.configDir}/matugen/templates/hyprland.lua"
        output_path = "${config.home.configDir}/hypr/hyprland.colors.lua"

        ${optionalString config.modules.shell.tmux.enable ''
          [templates.tmux]
          input_path = "${hey.configDir}/matugen/templates/tmux.conf"
          output_path = "${config.home.configDir}/tmux/dank-colors.conf"
        ''}
        ${optionalString config.modules.desktop.browsers.librewolf.enable ''
          [templates.librewolf]
          input_path = "${hey.configDir}/matugen/templates/librewolf.css"
          output_path = "${config.home.fakeDir}/.librewolf/gold3n.default/chrome/userChrome.colors.css"
        ''}
        ${optionalString config.modules.desktop.apps.rofi.enable ''
          [templates.rofi]
          input_path = "${hey.configDir}/matugen/templates/rofi.rasi"
          output_path = "${config.home.configDir}/rofi/themes/dank-colors.rasi"
        ''}
        ${optionalString config.modules.desktop.term.foot.enable ''
          [templates.foot]
          input_path = "${hey.configDir}/matugen/templates/foot.ini"
          output_path = "${config.home.configDir}/foot/dank-colors.ini"
        ''}
      '';

      # Maps the modified repository configurations natively
      "hypr" = {
        source = "${hey.configDir}/hypr";
        recursive = true;
      };
    };

    user.packages = with pkgs; [
      (catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "maroon";
      })
      catppuccin-cursors.mochaDark
      tela-circle-icon-theme

      # Reminder: DMS specific launcher entries have been omitted
      # since dms-shell is disabled and they will no longer function.
    ];
  };
}
