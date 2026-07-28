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
      services.openssh = {
        enable = true;

        settings = {
          # Mitigate brute-force attacks by strictly disabling password and keyboard-interactive authentication.
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;

          # Prevent complete system compromise via direct root access.
          # Administrative tasks must be performed by unprivileged users escalating via sudo/doas.
          PermitRootLogin = "no";

          # Enforce public key authentication explicitly.
          AuthenticationMethods = "publickey";

          # Disable X11 forwarding to reduce the overall attack surface, unless strictly required.
          X11Forwarding = false;
        };

        # Further restrict forwarding capabilities to prevent lateral network movement
        # in the event an unprivileged account is compromised.
        extraConfig = ''
          AllowAgentForwarding no
          AllowTcpForwarding yes
          AllowStreamLocalForwarding no
        '';
      };
      environment.etc."ssh/moduli".source = pkgs.runCommand "filterModuliFile" {} ''
        awk '$5 >= 3071' ${pkgs.openssh}/etc/ssh/moduli > $out
      '';
    }

    (mkIf config.modules.xdg.ssh.enable {
      # Ensure this directory exists and has correct permissions.
      systemd.user.tmpfiles.rules = ["d %h/.config/ssh 700 - - - -"];
    })
  ]);
}
