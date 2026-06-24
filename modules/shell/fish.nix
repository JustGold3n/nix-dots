{ hey, lib, config, options, pkgs, ... }:

with lib;
with hey.lib;
#let cfg = config.modules.shell.fish;
#in {
#  options.modules.shell.fish = with types; {
#    enable = mkBoolOpt false;
#
#    rcInit = mkOpt' lines "" ''
#      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshrc and sourced by
#      $XDG_CONFIG_HOME/zsh/.zshrc
#    '';
#    envInit = mkOpt' lines "" ''
#      Zsh lines to be written to ${config.home.configDir}/zsh/extra.zshenv and
#      sourced by $XDG_CONFIG_HOME/zsh/.zshenv
#    '';
#
#    rcFiles  = mkOpt (listOf (either str path)) [];
#    envFiles = mkOpt (listOf (either str path)) [];
#  };
#
#  config = mkIf cfg.enable {
    programs.fish.enable = true;

    users.defaultUserShell = pkgs.fish;

    # Some interactive shell utilies I find universally indispensible.
    user.packages = with pkgs; [
      at
      bat      # a better cat
      bc
      dust     # a better du
      eza      # a better ls
      fasd
      fd
      fzf
      gnumake
      libqalculate  # calculator cli w/ currency conversion
     # nix-zsh-completions
      ripgrep  # a better grep
      tokei    # for code statistics
      unar
      zip
      unzip
      vim
    ];

}
