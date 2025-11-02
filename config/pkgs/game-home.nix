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
  ];
}
