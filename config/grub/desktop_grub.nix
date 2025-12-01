{
  config,
  pkgs,
  lib,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = true;
      configurationLimit = 8;
    };

    efi.canTouchEfiVariables = true;
    timeout = 2;
  };
}
