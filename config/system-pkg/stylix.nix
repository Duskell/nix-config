{ config, pkgs, lib, stylix, self, ... }:

let
  cfg = config.style;
in
{
  options.style = {
    theme = lib.mkOption {
      type = lib.types.str;
      default = "horizon-dark";
      description = "Theme for stylix";
    };

    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = "${self}/resources/images/wallpapers/fever_dream.png";
      description = "Wallpaper for stylix";
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
      plymouth.enable = false;
    };

    stylix.polarity = "dark";

    stylix.image = cfg.wallpaper;

    stylix.fonts = {
      serif = {
        package = pkgs.eb-garamond;
        name = "EB Garamond";
      };

      sansSerif = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };

      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
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
