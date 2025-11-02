{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../config/system-pkg/systemd-timers.nix
    ../../config/system-pkg/podman.nix
    ../../config/system-pkg/minecraft-server.nix
  ];

  environment.systemPackages = with pkgs; [
    nmap
    python312Packages.speedtest-cli
  ];

  networking.hostName = "server";

  timers = {
    goSleep.enable = true;
    wakeUp.enable = true;
  };

  age.identityPaths = [
    "/root/.age/"
  ];
}
