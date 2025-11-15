{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    powertop
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";

  services.fail2ban.enable = true;
  services.fail2ban.jails.ssh = {
    enabled = true;
  };

  users.users.levente = {
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7o5QcA3e9o3D9ZjTo2tKBO7ccsQhgzch75XYPdUlR1 home-server"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPr70mAXr6Lio3NWtBltfGYJ6eSddPhZz7WM6Jy0dls"
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # WOL
  networking.interfaces.eno1.wakeOnLan.enable = true;
}
