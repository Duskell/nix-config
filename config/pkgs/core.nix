{ config, pkgs, lib, ... }:

with pkgs;
let
  global-python-packages = python-packages: with python-packages; [
    pip
    pytest
    python-dotenv
    requests
  ];
  py = python3.withPackages global-python-packages;
in {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat                       # A cat(1) clone with syntax highlighting and Git integration
    zoxide                    # A better cd
    coreutils                 # The GNU Core Utils
    dig                       # A DNS tool
    duf                       # Disk Usage/Free Utility
    eza                       # A Better ls in written in rust
    hdparm                    # A tool to get/set ATA/SATA drive parameters under Linux
    htop                      # An interactive process viewer
    inetutils                 # Collection of common network programs
    iotop                     # A tool to find out the processes doing the most IO
    lm_sensors                # Tools for reading hardware sensors
    lshw                      # Provide detailed information on the hardware configuration of the machine
    rsync                     # Fast incremental file transfer utility
    neovim                    # Text editor
    unrar                     # Utility for RAR archives
    unzip                     # An extraction utility for archives compressed in .zip format
    curl                      #
    zip                       # Compressor/archiver for creating and modifying zipfiles
    ethtool                   # Utility for controlling network drivers and hardware
    cifs-utils                # Tools for managing Linux CIFS client filesystems
  ];
}
