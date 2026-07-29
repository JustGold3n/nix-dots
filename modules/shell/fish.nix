{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
    enable = lib.mkEnableOption "fish shell configuration";
  };

  config = lib.mkIf cfg.enable {
    # Provision the required binaries system-wide
    environment.systemPackages = with pkgs; [
      eza
      zoxide
    ];

    programs.fish = {
      enable = true;

      # Replace ls with eza using NixOS-native fish aliases
      shellAliases = {
        ls = "eza --icons=always";
        la = "eza -a --icons=always";
        ll = "eza -l --icons=always";
        lla = "eza -la --icons=always";
        tree = "eza --tree --icons=always";
      };

      interactiveShellInit = ''
        set -U fish_greeting ""

        # Enable vim bindings
        #set -g fish_key_bindings fish_vi_key_bindings

        # Define cursor shapes for visual feedback in vi modes
        set -g fish_cursor_default block
        set -g fish_cursor_insert line
        set -g fish_cursor_replace_one underscore
        set -g fish_cursor_visual block

        # Initialize zoxide and natively override the cd command
        zoxide init fish --cmd cd | source
      '';
    };

    # Starship is supported at the NixOS system level for the prompt
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;

        character = {
          success_symbol = "[❯](bold blue)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold green)";
          vimcmd_replace_one_symbol = "[❮](bold purple)";
          vimcmd_replace_symbol = "[❮](bold purple)";
          vimcmd_visual_symbol = "[❮](bold yellow)";
        };

        directory = {
          style = "bold cyan";
        };

        git_branch = {
          format = "on [$symbol$branch]($style) ";
          style = "bold magenta";
        };
      };
    };
  };
}
