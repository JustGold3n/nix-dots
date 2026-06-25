let
   git="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOwL3589HLlSOLIkr5a6P6t8A2rJPh5S4UQtf7Z2CsgN gold3n@Saber";


in{
	"GitHubPrivateKey.age".publicKeys= [git];
}

