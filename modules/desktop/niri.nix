{ config, pkgs, ... }:

{
  programs.niri.enable = true;
  programs.xwayland.enable = true;

  home.packages = with pkgs; [
    xwayland-satellite 
    jq
  ];

    home.file.".config/niri/config.kdl".source = ../../config/niri/config.kdl;
    home.file.".config/niri/scripts" = {
    source = ../../config/niri/scripts;
    recursive = true;
    executable = true;  
}
