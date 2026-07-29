{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.gpg;
in {
  options.modules.services.gpg = {
    enable = mkEnableOption "Secure GPG and YubiKey Smartcard Service";
  };

  config = mkIf cfg.enable {
    # Enable the PC/SC Smart Card Daemon required for YubiKey communication
    services.pcscd.enable = true;

    # Grant proper hardware access permissions to the YubiKey via Udev
    services.udev.packages = [pkgs.yubikey-personalization];

    # Core cryptographic and smartcard management packages
    environment.systemPackages = with pkgs; [
      gnupg
      yubikey-manager
      yubikey-personalization
    ];

    # System-level GPG Agent Configuration
    # System-level GPG Agent Configuration
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;

      # Secure, terminal-based pinentry to prevent GUI spoofing.
      # mkForce overrides the existing pinentry-rofi configuration.
      pinentryPackage = lib.mkForce pkgs.pinentry-curses;

      # Enforce strict TTLs (in seconds) to minimize the window for cryptographic operations
      settings = {
        default-cache-ttl = 60;
        max-cache-ttl = 120;
        default-cache-ttl-ssh = 60;
        max-cache-ttl-ssh = 120;
      };
    }; # Automatically map the GPG terminal to the active Fish shell session
    # to ensure the curses pinentry renders correctly.
    programs.zsh.interactiveShellInit = ''
      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
    '';
  };
}
