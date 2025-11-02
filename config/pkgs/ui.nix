{ config, pkgs, inputs, self, ... }:

{
  imports = [
    ../../config/system-pkg/nvidia.nix
  ];

  boot = {
    kernelParams = [
      "simpledrm.disable=1"
    ];

    kernelModules = [ "i915" ];

    plymouth = {
      enable = true;
      theme = "kuro-the-cat";
      themePackages = with pkgs; [
        self.packages.${pkgs.system}.kuro-the-cat
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];

  users.users.levente.extraGroups = [
    "video"
    "audio"
  ];

  # Enable the Xorg system.
  services.xserver.enable = true;

  # Configure keymap in Xorg
  services.xserver.xkb = {
    layout = "hu";
    variant = "standard";
  };

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  services.pulseaudio.enable = false;

  # Enable sound with pipewire.
  #security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
