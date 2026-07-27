{
  hey,
  lib,
  options,
  config,
  pkgs,
  ...
}:
with builtins;
with lib;
with hey.lib; let
  hostKey = "/etc/ssh/ssh_host_ed25519_key";
in {
  imports = [hey.modules.agenix.age];

  options.modules.agenix = with types; {
    dirs = mkOpt (listOf (either str path)) [
      "${hey.hostDir}/secrets"
      "${hey.configDir}/secrets"
    ];
  };

  config = {
    assertions = [
      {
        assertion = config.age.secrets == {} || (pathExists hostKey);
        message = "Secrets provided, but no host key was found";
      }
    ];

    # Each system gets a host key, used for decrypting Agenix secrets and as a
    # deployment key via Git. It's expected to be provisioned before the system
    # is initially installed.
    programs.ssh.extraConfig = ''
      Host *
        IdentityFile ${hostKey}
    '';

    # Ensure this hostkey is the default key used by agenix.
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "agenix" ''
        ARGS=( "$@" )
        ${optionalString config.modules.xdg.ssh.enable ''
          if [[ "''${ARGS[*]}" != *"--identity"* && "''${ARGS[*]}" != *"-i"* ]]; then
            for hostkey in "${hostKey}"; do
              if [[ -f "$hostkey" ]]; then
                ARGS=( --identity "$hostkey" "''${ARGS[@]}" )
              fi
            done
          fi
        ''}
        exec ${hey.inputs.agenix.packages.${stdenv.hostPlatform.system}.default}/bin/agenix "''${ARGS[@]}"
      '')
    ];

    age = {
      identityPaths = [hostKey];

      # Your explicit secrets are merged with the dynamic directory loading logic
      secrets =
        {
          keepassxc-password = {
            file = ./secrets/keepassxc-password.age;
            mode = "0400";
            owner = "gold3n";
            group = "users";
          };

          ssh-personal = {
            file = ./secrets/ssh-personal.age;
            path = "/home/gold3n/.ssh/id_personal";
            mode = "0400";
            owner = "gold3n";
            group = "users";
          };

          ssh-github = {
            file = ./secrets/ssh-github.age;
            path = "/home/gold3n/.ssh/id_github";
            mode = "0400";
            owner = "gold3n";
            group = "users";
          };

          # ssh-work = {
          #   file = ./secrets/ssh-work.age;
          #   path = "/home/gold3n/.ssh/id_work_yubikey";
          #   mode = "0400";
          #   owner = "gold3n";
          #   group = "users";
          # };
        }
        // foldl (a: b: a // b) {}
        (map (dir:
            mapAttrs'
            (n: v:
              nameValuePair (removeSuffix ".age" n) {
                file = "${dir}/${n}";
                owner = mkDefault config.user.name;
              })
            (import "${dir}/secrets.nix"))
          (filter (dir: pathExists "${dir}/secrets.nix")
            config.modules.agenix.dirs));
    };
  };
}
