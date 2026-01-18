{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../home-pkg/vscode.nix
  ];

  home.packages = with pkgs; [
    android-studio
    gcc
    gnumake
    jq
    nodejs_24
    stdenv
    makeWrapper
    pmbootstrap
    gnumake
    libgcc
    unityhub
    devenv
  ];
}
