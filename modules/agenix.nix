{
  config,
  pkgs,
  ...
}: {
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

    ssh-work = {
      file = ./secrets/ssh-work.age;
      path = "/home/gold3n/.ssh/id_work_yubikey";
      mode = "0400";
      owner = "gold3n";
      group = "users";
    };
  };
}
