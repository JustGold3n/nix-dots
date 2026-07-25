  hey,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Keep Fish enabled in NixOS
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;

    # Move Starship into the home-manager block
    home-manager.users.${config.user.name} = {
      programs.starship = {
        enable = true;
        enableFishIntegration = true; # This will now work
        settings = {
          add_newline = false;
          character = {
            success_symbol = "[❯](bold blue)";
            error_symbol = "[❯](bold red)";
            vimcmd_symbol = "[❮](bold green)";
          };
          directory = {
            style = "bold blue";
            truncate_to_repo = true;
            truncation_length = 3;
          };
          git_branch = {
            style = "italic blue";
            symbol = " ";
          };
          git_status = {
            style = "italic blue";
          };
        };
      };
    };

    # Keep your packages here
    user.packages = with pkgs; [
      at
      bat
      bc
      dust
      eza
      fasd
      fd
      fzf
      gnumake
      libqalculate
      ripgrep
      tokei
      unar
      zip
      unzip
    ];
  };
}
