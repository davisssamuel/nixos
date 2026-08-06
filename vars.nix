{
  users = {
    sam = {
      username = "sam";
      hashedPassword = "$y$j9T$mxo3622Q6iIUtX92k.pt..$lfXhWKhD8.pfQGOX5y.Q0ENpnOoF9thtufNYXJ7OOP1";
      macbookPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWklVXOkuctgqNhRa7BnysWiB9ZtQmrAdCrxvrFnjb3";
    };
  };

  hosts = {
    tars = {
      hostId = "ff328b24";
      tunnelId = "5918d496-1a1c-47fd-b8d5-bd6320ed7b2b";
    };
    case = {
      hostId = "0ae92de1";
      tunnelId = "bb45604a-1292-447a-a349-d619f43b798f";
    };
  };

  sync = {
    remoteHost = "tars";
    remoteDataset = "rpool";
    localPrefix = "rpool/backup";
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3FwNyKNKzSMxBotGcIyg8vPJ4Y53CUBdTBWoZ9wMbq";
  };
}
