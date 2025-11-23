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
      "snat-subnet-routes"
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

  boot.kernelModules = [
    "xt_nat"
    "xt_MASQUERADE"
    "iptable_nat"
    "iptable_filter"
    "iptable_mangle"
    "iptable_raw"
    "ip6table_nat"
    "ip6table_filter"
    "ip6table_mangle"
    "ip6table_raw"
    "nf_nat"
    "nf_conntrack"
  ];

  age.identityPaths = [
    "/root/.age/server.agekey"
  ];
}
