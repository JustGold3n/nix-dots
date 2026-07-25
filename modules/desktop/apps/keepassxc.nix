{
  config,
  pkgs,
  ...
}: {
  programs.keepassxc = {
    enable = true;
    settings = {
      FdoSecrets = {
        Enabled = true;
      };
      SSHAgent = {
        Enabled = true;
      };
    };
  };
}
