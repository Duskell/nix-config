{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_hardened;

  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 8;
    };

    efi.canTouchEfiVariables = true;
    timeout = 3;
  };
}
