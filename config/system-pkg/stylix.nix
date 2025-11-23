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
      grub.useWallpaper = true;
      plymouth.enable = false;
      starship.enable = true;
    };

    stylix.polarity = "dark";

    stylix.image = cfg.wallpaper;

    stylix.fonts = {
      serif = {
        package = pkgs.eb-garamond;
        name = "EB Garamond";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.tinos;
        name = "Tinos Nerd Font";
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
