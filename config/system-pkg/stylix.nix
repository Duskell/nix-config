{
  config,
  pkgs,
  lib,
  stylix,
  self,
  ...
}: let
  cfg = config.style;
in {
  options.style = {
    theme = lib.mkOption {
      type = lib.types.str;
      default = "horizon-dark";
      description = "Theme for stylix";
    };

    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "fever_dream.png";
      description = "Wallpaper for stylix from the resources dir";
    };
  };

  imports = [
    stylix.nixosModules.stylix
  ];

  config = {
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";

    stylix.targets = {
      grub.enable = true;
      grub.useWallpaper = true;
      plymouth.enable = false;
      qt.enable = false;
    };

    stylix.polarity = "dark";

    stylix.image = "${self}/resources/images/wallpapers/" + cfg.wallpaper;

    stylix.fonts = {
      serif = {
        package = pkgs.eb-garamond;
        name = "EB Garamond";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    stylix.icons = {
      enable = true;
    };
  };
}
