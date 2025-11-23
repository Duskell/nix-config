{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../config/system-pkg/copyparty.nix
    ../../config/system-pkg/systemd-timers.nix
    ../../config/system-pkg/podman.nix
    ../../config/system-pkg/minecraft-server.nix
  ];

  environment.systemPackages = with pkgs; [
    nmap
    python312Packages.speedtest-cli
  ];

  networking.hostName = "server";

  tail = {
    flags = [
      "advertise-exit-node"
    ];
  };

  timers = {
    goSleep.enable = true;
    wakeUp.enable = true;
  };

  pod = {
    mc-access = {
      enable = true;
      autoStart = true;
      root = "/srv/mc-access";
    };
  };

  # FIREWALL

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ 80 22 443 25565 3210 config.services.tailscale.port ];
    interfaces.podman1 = {
      allowedUDPPorts = [ 53 ]; # this needs to be there so that containers can look eachother's names up over DNS
    };
  };

  age.identityPaths = [
    "/root/.age/server.agekey"
  ];
}
