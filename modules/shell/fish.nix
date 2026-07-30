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

      # Direct binary resolution prevents default coreutils from taking precedence
      shellAliases = {
        ls = "eza --icons=always";
        la = "eza -a --icons=always";
        lla = "eza -la --icons=always";
        tree = "eza --tree --icons=always";
      };

      interactiveShellInit = ''
        set -U fish_greeting ""

        # Enforce native Fish syntax highlighting colors
        set -g fish_color_command green --bold
        set -g fish_color_param cyan
        set -g fish_color_error red --bold
        set -g fish_color_quote yellow
        set -g fish_color_redirection magenta
        set -g fish_color_end blue
        set -g fish_color_comment black

        # Initialize zoxide and natively override the cd command
        zoxide init fish --cmd cd | source

        # Fish requires keybindings to be encapsulated in this function to persist
        function fish_user_key_bindings
            # Enable vim bindings natively
            fish_vi_key_bindings

            # Bind Ctrl+Backspace to remove the previous word
            # Supports standard escape sequences (\cH for Ctrl-H/Backspace, \e\x7f for Alt-Backspace)
            bind -M insert \cH backward-kill-word
            bind -M default \cH backward-kill-word
            bind -M insert \e\x7f backward-kill-word
            bind -M default \e\x7f backward-kill-word
        end

        # Define cursor shapes for visual feedback in vi modes
        set -g fish_cursor_default block
        set -g fish_cursor_insert line
        set -g fish_cursor_replace_one underscore
        set -g fish_cursor_visual block
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
