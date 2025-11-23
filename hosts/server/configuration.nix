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
    checkReversePath = "loose";
  };

  # NAT

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.default.forwarding" = 1;
    "net.ipv4.conf.all.src_valid_mark" = 1;
    "net.ipv4.conf.default.src_valid_mark" = 1;
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    internalInterfaces = [ "tailscale0" ];
    externalInterface = "enp0s31f6";
    forwardPorts = [
      {
        sourcePort = 5555;
        proto = "tcp";
        destination = "192.168.1.1";
      }
    ];
  };

  age.identityPaths = [
    "/root/.age/server.agekey"
  ];
}
