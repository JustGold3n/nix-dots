{
  config,
  pkgs,
  lib,
  ...
}: {
  # ==========================================
  # NixOS System-Level Configuration
  # ==========================================

  # Hardware Authentication Prerequisites
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [yubikey-personalization];

  # Secret Service Exclusivity (Prevents DBus race conditions)
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  security.pam.services.login.enableGnomeKeyring = lib.mkForce false;

  # ==========================================
  # Home Manager User-Level Configuration
  # ==========================================

  home-manager.users.gold3n = {
    programs.keepassxc = {
      enable = true;
      settings = {
        General = {
          ConfigVersion = 2;
          UseHardwareKeys = true;
        };
        FdoSecrets = {
          Enabled = true;
          ConfirmAccess = true;
        };
      };
    };

    # Ensure KeePassXC waits for Agenix decryption before launching
    systemd.user.services.keepassxc = {
      Unit = {
        After = ["agenix.service"];
        Wants = ["agenix.service"];
      };
    };
  };
}
