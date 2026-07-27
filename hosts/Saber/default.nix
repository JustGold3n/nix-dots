# Saber - Dell XPS 13 Plus 9320
{
  hey,
  lib,
  ...
}:
with lib;
with builtins; {
  system = "x86_64-linux";

  imports = [
    ./hardware-configuration.nix
  ];

  ## Flake modules
  modules = {
    xdg.ssh.enable = true;

    profiles = {
      role = "workstation";
      user = "gold3n";
      networks = ["ca" "ts0"];
      hardware = [
        "bluetooth"
        "wifi"
        "pc/laptop"
        "audio"
        "ssd"
      ];
    };

    desktop = {
      hyprland = rec {
        enable = true;
        monitors = [
          {
            output = "eDP-1";
            primary = true;
          }
        ];
        extraConfig = ''
          hl.workspace_rule({ workspace = "special:term", gaps_out = 100, on_created_empty = "hey .scratch term" })
          hl.workspace_rule({ workspace = "special:pad", gaps_in = 3, gaps_out = { top = 40, left = 80, bottom = 40, right = 80 }})

          -- trigger when the lid is up
          -- hl.bind("switch:off:Lid Switch", hl.dsp.dpms({ action = "disable" }))
          -- trigger when the lid is down
          -- hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off && hey .lock --no-fade-in --no-fade-out"))
        '';
      };

      apps.rofi.enable = true;
      term.default = "foot";
      term.foot.enable = true;
      browsers.default = "zen-browser";
      browsers.zen.enable = true;
      media.cad.enable = true;
      media.graphics.enable = true;
      media.music.enable = true;
      media.video.enable = true;
    };

    dev = {
      cc.enable = true;
    };

    editors = {
      nvf.enable = true;
      default = "nvim";
      #  environment.variables.EDITOR = "nvim";
      #vim.enable = true;
    };

    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
      fish.enable = true;
    };

    services = {
      ssh.enable = true;
    };

    system = {
      utils.enable = true;
      fs.enable = true;
    };
    # virt.qemu.enable = true;
  };

  ## Local config
  config = {...}: {
    networking.networkmanager.enable = true;
    services.upower.enable = true;
    services.fprintd.enable = true;
    security.pam.services.sudo.fprintAuth = true;
  };

  ## Hardware config
  hardware = {pkgs, ...}: {
    boot.initrd = {
      kernelModules = ["dm-snapshot"];
    };

    services.tlp.settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MAX_PERF_ON_BAT = 50;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 50;
    };

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/c5d83563-9481-4f7f-85c1-92fc9ad436fa";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/1ED9-9FBD";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/df1e5219-884f-4142-b814-9f924345e412";}
    ];
  };
}
