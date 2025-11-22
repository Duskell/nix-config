{ config, pkgs, lib, self, ... }:

{
  age.secrets = {
    tailscale-key = {
      file = "${self}/secrets/tailscale-key.age";
      path = "/run/secrets/tailscale-key";
      mode = "0400";
    };

    ssh-github-duskell = {
      file = "${self}/secrets/ssh-github-duskell.age";
      path = "/var/lib/ssh/github_id";
      mode = "0640"; # rw for owner, r for group
      owner = "levente";
      group = "sshkeys";
    };

    copyparty-levente = {
      file = "${self}/secrets/copyparty-levente.age";
      path = "/var/lib/copyparty/levente_password";
      mode = "0640"; # rw for owner, r for group
      owner = "levente";
      group = "copyparty";
    };

    copyparty-attila = {
      file = "${self}/secrets/copyparty-attila.age";
      path = "/var/lib/copyparty/attila_password";
      mode = "0640"; # rw for owner, r for group
      owner = "levente";
      group = "copyparty";
    };
  };
}
