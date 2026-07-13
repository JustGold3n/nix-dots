{ hey, lib, config, pkgs, ... }:

with lib;
with hey.lib;
let 
  cfg = config.modules.editors.nvf;
  isMaximal = true; 
in {
  imports = [
    hey.inputs.nvf.nixosModules.default
  ];

  options.modules.editors.nvf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
        viAlias = true;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };        
        opts.expandtab = true;

        spellcheck = {
          enable = true;
          programmingWordlist.enable = false;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          trouble.enable = true;
          lspSignature.enable = !isMaximal;
          otter-nvim.enable = isMaximal;
          nvim-docs-view.enable = isMaximal;
          presets.harper.enable = isMaximal;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          nix.enable = true;
          markdown.enable = true;

          bash.enable = isMaximal;
          clang.enable = isMaximal;
          cmake.enable = isMaximal;
          css.enable = isMaximal;
          scss.enable = isMaximal;
          html.enable = isMaximal;
          json.enable = isMaximal;
          sql.enable = isMaximal;
          java.enable = isMaximal;
          kotlin.enable = isMaximal;
          typescript.enable = isMaximal;
          go.enable = isMaximal;
          lua.enable = isMaximal;
          zig.enable = isMaximal;
          python.enable = isMaximal;
          typst.enable = isMaximal;
          rust = {
            enable = isMaximal;
            extensions.crates-nvim.enable = isMaximal;
          };
          toml.enable = isMaximal;
          xml.enable = isMaximal;
          tex.enable = isMaximal;
          docker.enable = isMaximal;
          env.enable = isMaximal;

          openscad.enable = false;
          arduino.enable = false;
          assembly.enable = false;
          astro.enable = false;
          nu.enable = false;
          csharp.enable = false;
          julia.enable = false;
          vala.enable = false;
          scala.enable = false;
          r.enable = false;
          gleam.enable = false;
          glsl.enable = false;
          dart.enable = false;
          ocaml.enable = false;
          elixir.enable = false;
          haskell.enable = false;
          hcl.enable = false;
          ruby.enable = false;
          fsharp.enable = false;
          just.enable = false;
          make.enable = false;
          qml.enable = false;
          jinja.enable = false;
          svelte.enable = false;
          vue.enable = false;
          tsx.enable = false;
          liquid.enable = false;
          tera.enable = false;
          twig.enable = false;
          gettext.enable = false;
          fluent.enable = false;
          jq.enable = false;
          fish.enable = false;
          standard-ml.enable = false;
          pug.enable = false;

          nim.enable = false;
        };

        visuals = {
          nvim-scrollbar.enable = isMaximal;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          blink-indent.enable = true;
          indent-blankline.enable = true;
          cellular-automaton.enable = false;
        };

        statusline = {
          lualine = {
            enable = true;
            theme = "catppuccin";
          };
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = false;
        };

        autopairs.nvim-autopairs.enable = true;

        autocomplete = {
          nvim-cmp.enable = !isMaximal;
          blink-cmp.enable = isMaximal;
        };

        snippets.luasnip.enable = true;

        filetree = {
          neo-tree.enable = true;
        };

        tabline = {
          nvimBufferline.enable = true;
        };

        treesitter.context.enable = true;

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        telescope.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false;
          neogit.enable = isMaximal;
        };

        minimap = {
          minimap-vim.enable = false;
          codewindow.enable = false;
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = isMaximal;
        };

        notify = {
          nvim-notify.enable = true;
        };

        projects = {
          project-nvim.enable = isMaximal;
        };

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          diffview-nvim.enable = true;
          yanky-nvim.enable = false;
          qmk-nvim.enable = false;
          icon-picker.enable = isMaximal;
          surround.enable = isMaximal;
          leetcode-nvim.enable = isMaximal;
          multicursors.enable = isMaximal;
          smart-splits.enable = isMaximal;
          undotree.enable = isMaximal;
          nvim-biscuits.enable = isMaximal;
          grug-far-nvim.enable = isMaximal;

          motion = {
            hop.enable = true;
            leap.enable = true;
            precognition.enable = isMaximal;
          };

          images = {
            image-nvim.enable = false;
            img-clip.enable = isMaximal;
          };
        };

        notes = {
          neorg.enable = false;
          orgmode.enable = false;
          todo-comments.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = true;
          modes-nvim.enable = false;
          illuminate.enable = true;

          breadcrumbs = {
            enable = isMaximal;
            navbuddy.enable = isMaximal;
          };

          smartcolumn = {
            enable = true;
            setupOpts.custom_colorcolumn = {
              nix = "110";
              ruby = "120";
              java = "130";
              go = ["90" "130"];
            };
          };
          fastaction.enable = true;
        };

        assistant = {
          chatgpt.enable = false;
          copilot = {
            enable = false;
            cmp.enable = isMaximal;
          };
          codecompanion-nvim.enable = false;
          avante-nvim.enable = isMaximal;
        };

        session = {
          nvim-session-manager.enable = false;
        };

        gestures = {
          gesture-nvim.enable = false;
        };

        comments = {
          comment-nvim.enable = true;
        };

        presence = {
          neocord.enable = false;
        };
      };
    };
  };
}
