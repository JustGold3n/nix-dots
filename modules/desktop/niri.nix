{ hey, lib, config, pkgs, ... }:

with lib;
with hey.lib;
let
  cfg = config.modules.desktop.niri;
in {
  options.modules.desktop.niri = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.niri.enable = true;
    programs.xwayland.enable = true;

    user.packages = with pkgs; [
      xwayland-satellite
      jq
    ];

    # Use the repository's native config variable and map the entire directory recursively
    home.configFile = {
      "niri" = {
        source = "${hey.configDir}/niri";
        recursive = true;
      };
    };
  };
}
