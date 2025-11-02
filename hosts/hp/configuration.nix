{ config, pkgs, lib, ... }:

{
  imports = [
    ../../config/system-pkg/kde.nix
    ../../config/system-pkg/stylix.nix
    ../../config/system-pkg/podman.nix
    ../../config/system-pkg/steam.nix
  ];

  environment.systemPackages = with pkgs; [

  ];

  users.users.levente.extraGroups = [ "flatpak" ];

  networking.hostName = "hp";

  age.identityPaths = [
    "/home/levente/.age/hp.agekey"
  ];

  xdg.portal.enable = true;

  services.flatpak.enable = true;
}
