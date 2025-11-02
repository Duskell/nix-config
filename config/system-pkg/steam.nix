{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;

    extraPackages = with pkgs; [
      gamemode
      mangohud
      protonup-ng
    ];
  };
}
