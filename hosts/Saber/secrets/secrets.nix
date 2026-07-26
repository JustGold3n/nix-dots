let
  # System Host Key (Required for the machine to decrypt secrets at boot)
  systemKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... root@hostname";

  # Personal Software SSH Public Keys
  personalKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... personal_email@example.com";
  githubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOwL3589HLlSOLIkr5a6P6t8A2rJPh5S4UQtf7Z2CsgN gold3n@Saber";

  # Hardware-Backed YubiKey Public Key (FIDO2/U2F)
  # Note: The sk-ssh-ed25519 prefix denotes a security key
  #  workYubiKey = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAI... work_email@example.com";

  # Grouping for convenience
  allKeys = [systemKey personalKey githubKey]; #  workYubiKey];
in {
  # Define the secrets and assign authorized decryption keys
  "secrets/keepassxc-password.age".publicKeys = allKeys;
  "secrets/ssh-personal.age".publicKeys = allKeys;
  "secrets/ssh-github.age".publicKeys = allKeys;
  #  "secrets/ssh-work.age".publicKeys = allKeys;
}
