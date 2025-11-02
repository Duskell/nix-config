{ config, pkgs, lib, ... }:

{
  imports = [
    ../../config/system-pkg/kde.nix
    ../../config/system-pkg/stylix.nix
    ../../config/system-pkg/podman.nix
    ../../config/system-pkg/steam.nix
  ];

  environment.systemPackages = with pkgs; [
    dracut
  ];

  users.users.levente.extraGroups = [ "flatpak" ];

  networking.hostName = "hp";

  # FIREWALL

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [  22 config.services.tailscale.port ];
    interfaces.podman1 = {
      allowedUDPPorts = [ 53 ]; # this needs to be there so that containers can look eachother's names up over DNS
    };
  };

  age.identityPaths = [
    "/home/levente/.age/hp.agekey"
  ];

  xdg.portal.enable = true;

  services.flatpak.enable = true;
}
