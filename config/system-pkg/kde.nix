{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    kdePackages.kde-cli-tools
    kdePackages.plasma-workspace
  ];

  # PLASMA config
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  # SDDM config
  services.displayManager.sddm.enable = true;

  services.displayManager.sddm.wayland.enable = true;

  # KDE apps
  programs.kdeconnect.enable = true;
}
