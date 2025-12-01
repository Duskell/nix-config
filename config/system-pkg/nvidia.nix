{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nvidia;
in {
  options.nvidia = {
    openSource = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the open-source NVIDIA kernel driver. (not Nouveau)";
    };

    finegrained = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Fine-grained power management. Turns off GPU when not in use.";
    };

    intelBusId = lib.mkOption {
      type = lib.types.str;
      default = "PCI:0:2:0";
      description = "Make sure to use the correct Bus ID values for your system!";
    };

    nvidiaBusId = lib.mkOption {
      type = lib.types.str;
      default = "PCI:01:0:0";
      description = "Make sure to use the correct Bus ID values for your system!";
    };

    portable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Optional boot opion for nvidia-offload";
    };
  };

  config = {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = cfg.finegrained;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = cfg.openSource;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.nvidia.prime = {
      offload.enable = true;
      offload.offloadCmdMainProgram = "prime-run";
      offload.enableOffloadCmd = true;

      # Make sure to use the correct Bus ID values for your system!
      intelBusId = cfg.intelBusId;
      nvidiaBusId = cfg.nvidiaBusId;
    };

    specialisation = lib.mkIf cfg.portable {
      on-the-go.configuration = {
        system.nixos.tags = ["Portable"];
        hardware.nvidia = {
          prime.offload.enable = lib.mkForce true;
          prime.offload.enableOffloadCmd = lib.mkForce true;
          prime.sync.enable = lib.mkForce false;
        };
      };
    };

    # Vulkan + OpenGL packages (64-bit + 32-bit)
    hardware.graphics.extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];
    hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [
      vulkan-loader
    ];
  };
}
