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

    home.configFile = {
      "niri/config.kdl".source = ../../config/niri/config.kdl;
      "niri/scripts" = {
        source = ../../config/niri/scripts;
        recursive = true;
      };
    };
  };
}
