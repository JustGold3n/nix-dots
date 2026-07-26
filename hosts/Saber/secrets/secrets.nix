let
  # System Host Key (Required for the machine to decrypt secrets at boot)
  systemKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB3zh/bmO+PBMdRoQXz9NDi5flaW9pR6e7uHVhcmeHgz system";

  # Personal Software SSH Public Keys
  personalKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHob3EPR4AqLhBliCzbGm6BpPYfBxg7874sbRJjlqDkg personal";
  githubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOwL3589HLlSOLIkr5a6P6t8A2rJPh5S4UQtf7Z2CsgN gold3n@Saber";

  # Hardware-Backed YubiKey Public Key (FIDO2/U2F)
  # Note: The sk-ssh-ed25519 prefix denotes a security key
  #  workYubiKey = "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAI... work_email@example.com";

  # Grouping for convenience
  allKeys = [systemKey personalKey githubKey]; #  workYubiKey];
in {
  # Define the secrets and assign authorized decryption keys
  "keepassxc-password.age".publicKeys = allKeys;
  "ssh-personal.age".publicKeys = allKeys;
  "ssh-github.age".publicKeys = allKeys;
  #  "secrets/ssh-work.age".publicKeys = allKeys;
}
