# modules/themes/autumnal/default.nix --- a dark, pastel theme

{ hey, heyBin, lib, config, pkgs, ... } @ args:

with lib;
with hey.lib;
let cfg = config.modules.theme;
in mkIf (cfg.active == "autumnal") (mkMerge [
  {
    user.packages = with pkgs; [
      adwaita-qt
      adwaita-qt6
      gnome-themes-extra
      adwaita-icon-theme
    ];

    home-manager.users.${config.user.name} = {
      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "adwaita";
        style.name = "adwaita-dark";
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
        };
      };
    };

    modules = {
      # Keep your existing shell/browser overrides here
    };
  }

  # Keep your existing mkIf configurations below...
])
