{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.desktop.apps.vesktop;
in {
  options.modules.desktop.apps.vesktop = {
    enable = lib.mkEnableOption "Vesktop";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vesktop
    ];
  };
}
