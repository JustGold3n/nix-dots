let
   git="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF+0i+FdsgBsZ3Z0ivND/SSxo+zbegfe5U8jCcVr82Ru";


in{
	"GitHubPrivateKey.age".publicKeys= [git];
}

