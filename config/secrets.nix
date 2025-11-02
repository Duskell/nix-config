{ config, pkgs, lib, inputs, ... }:

{
  age.secrets = {
    tailscale-key = {
      file = "${inputs.self}/secrets/tailscale-key.age";
      path = "/run/secrets/tailscale-key";
      mode = "0400";
    };

    ssh-github-duskell = {
      file = "${inputs.self}/secrets/ssh-github-duskell.age";
      path = "/var/lib/ssh/github_id";
      mode = "0640"; # rw for owner, r for group
      owner = "levente";
      group = "sshkeys";
    };
  };
}
