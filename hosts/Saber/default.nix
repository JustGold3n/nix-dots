# Saber - Dell XPS 13 Plus 9320
{
  hey,
  lib,
  ...
}:
with lib;
with builtins;
{
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
      niri.enable = true;

      apps.rofi.enable = true;
      apps.quickshell.enable = true;
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
      default = "nvim";
      vim.enable = true;
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

    virt.qemu.enable = true;
  };

  ## Local config
  config = {...}: {
    networking.networkmanager.enable = true;
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
