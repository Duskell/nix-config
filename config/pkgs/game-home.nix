{ config, pkgs, osConfig, ... }:

{
  imports = [
    ../home-pkg/vscode.nix
  ];

  home.packages = with pkgs; [
    steamcmd
    prismlauncher 
    lutris
    winetricks
    qbittorrent
    wineWowPackages.full
    dotnetCorePackages.runtime_8_0-bin
  ];
}
