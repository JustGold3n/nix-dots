{
  hey,
  lib,
  config,
  options,
  pkgs,
  ...
}:
with lib;
with hey.lib; let
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Forcefully disable the default SSH agent to allow GCR SSH Agent to handle it
      programs.ssh.startAgent = lib.mkForce true;

      services.openssh = {
        enable = true;
        settings = {
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = false;
        };
        # Suppress superfluous TCP traffic on new connections. Undo if using SSSD.
        extraConfig = ''GSSAPIAuthentication no'';
        # Deactivate short moduli
        moduliFile = pkgs.runCommand "filterModuliFile" {} ''
          awk '$5 >= 3071' "${config.programs.ssh.package}/etc/ssh/moduli" >"$out"
        '';
        matchBlocks = {
          "github.com" = {
            identityFile = "~/.ssh/id_github";
            identitiesOnly = true;
          };
          "work.internal" = {
            hostname = "work.internal";
            identityFile = "~/.ssh/id_work_yubikey";
            identitiesOnly = true;
          };
          "*" = {
            identityFile = "~/.ssh/id_personal";
          };
        };
      };
    }

    (mkIf config.modules.xdg.ssh.enable {
      # Ensure this directory exists and has correct permissions.
      systemd.user.tmpfiles.rules = ["d %h/.config/ssh 700 - - - -"];
    })
  ]);
}
