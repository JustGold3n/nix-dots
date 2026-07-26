with builtins;
with lib;
with hey.lib; let
  hostKey = "/etc/ssh/host_ed25519";
in {
  imports = [hey.modules.agenix.age];

  options.modules.agenix = with types; {
    dirs = mkOpt (listOf (either str path)) [
      "${hey.hostDir}/secrets"
      "${hey.configDir}/secrets"
    ];
  };

  age.secrets = {
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

    #    ssh-work = {
    #      file = ./secrets/ssh-work.age;
    #      path = "/home/gold3n/.ssh/id_work_yubikey";
    #      mode = "0400";
    #      owner = "gold3n";
    #      group = "users";
    #    };
  };
}
