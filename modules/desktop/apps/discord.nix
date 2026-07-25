# modules/desktop/apps/steam.nix
{
  hey,
  heyBin,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.desktop.apps.discord;
in {
  options.modules.desktop.apps.discord = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vesktop
    ];
  };
}
