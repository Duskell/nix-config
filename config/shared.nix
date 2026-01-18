{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.scanRandMacAddress = true;

  boot = {
    blacklistedKernelModules = [
      # If i ever need to blacklist modules
    ];

    kernelParams = [
      "intel_pstate=active"
      "transparent_hugepage=never"
      "intel_iommu=on"
      "iummo=pt"
      "tcp_fastopen=3"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = lib.mkDefault 0;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 1024 * 8;
    }
  ];

  time.timeZone = "Europe/Budapest";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "hu";

  hardware.enableAllFirmware = true;

  users.groups.sshkeys = {};

  users.groups.copyparty = {};

  users.groups.git = {};

  users.users.levente = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "sshkeys"
      "copyparty"
      "git"
    ];
  };

  nix.settings.trusted-users = ["root" "levente"];

  programs.ssh = {
    extraConfig = ''
      Host github.com
        IdentityFile /var/lib/ssh/github_id
        IdentitiesOnly yes
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "Duskell";
      user.email = "duskell@proton.me";
      init.defaultBranch = "main";
      pull.rebase = true;
      color.ui = "auto";
      core.autocrlf = "input";
      fetch.parallel = "8";
      log.decorate = "auto";
      log.abbrev = "12";
      commit.gpgsign = true;
    };
  };

  # Flakes
  #nix.package = pkgs.nixVersion.latest;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Timesync
  #services.timesyncd.enable = true;

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22 5500];

  services.syncthing.openDefaultPorts = true;
  services.openssh.openFirewall = true;

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    #nvidia.acceptLicense = true;
    permittedInsecurePackages = [
      # Placeholder
    ];
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        # Placeholder
      ];
  };

  #systemd.services.startupTasks = {
  #  wantedBy = [ "multi-user.target" ];
  #  description = "Extra tasks";
  #  script = "startup";
  #  serviceConfig = {
  #    Type = "oneshot";
  #    User = "levente";
  #  };
  #};

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # fonts
  fonts.packages = with pkgs; [
    # Silence is golden
  ];

  environment.shellInit = ''
    eval "$(zoxide init bash)"
    alias cd="z"
    alias pull='sudo git pull origin main'
    alias rb='sudo nixos-rebuild switch --flake .#'
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
