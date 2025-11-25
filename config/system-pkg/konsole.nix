{ config, pkgs, lib, self, ... }:

let
  cfg = config.konsole;

  boolToString = value: if value then "true" else "false";

  floatToString = value: builtins.toString value;

  fontSpec = family: size: "${family},${toString size},-1,5,50,0,0,0,0,0,0,0,0,0,0,0";

  modernPalette = with config.lib.stylix.colors; {
    background = "${base00-rgb-r}, ${base00-rgb-g}, ${base00-rgb-b}";
    backgroundIntense = "${base01-rgb-r}, ${base01-rgb-g}, ${base01-rgb-b}";
    foreground = "${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}";
    foregroundIntense = "${base07-rgb-r}, ${base07-rgb-g}, ${base07-rgb-b}";
    cursor = "${base0A-rgb-r}, ${base0A-rgb-g}, ${base0A-rgb-b}";
    selection = "${base02-rgb-r}, ${base02-rgb-g}, ${base02-rgb-b}";
    color0 = "${base00-rgb-r}, ${base00-rgb-g}, ${base00-rgb-b}";
    color1 = "${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}";
    color2 = "${base0B-rgb-r}, ${base0B-rgb-g}, ${base0B-rgb-b}";
    color3 = "${base0A-rgb-r}, ${base0A-rgb-g}, ${base0A-rgb-b}";
    color4 = "${base0D-rgb-r}, ${base0D-rgb-g}, ${base0D-rgb-b}";
    color5 = "${base0E-rgb-r}, ${base0E-rgb-g}, ${base0E-rgb-b}";
    color6 = "${base0C-rgb-r}, ${base0C-rgb-g}, ${base0C-rgb-b}";
    color7 = "${base05-rgb-r}, ${base05-rgb-g}, ${base05-rgb-b}";
    color8 = "${base03-rgb-r}, ${base03-rgb-g}, ${base03-rgb-b}";
    color9 = "${base09-rgb-r}, ${base09-rgb-g}, ${base09-rgb-b}";
    color10 = "${base0B-rgb-r}, ${base0B-rgb-g}, ${base0B-rgb-b}";
    color11 = "${base0A-rgb-r}, ${base0A-rgb-g}, ${base0A-rgb-b}";
    color12 = "${base0D-rgb-r}, ${base0D-rgb-g}, ${base0D-rgb-b}";
    color13 = "${base0E-rgb-r}, ${base0E-rgb-g}, ${base0E-rgb-b}";
    color14 = "${base0C-rgb-r}, ${base0C-rgb-g}, ${base0C-rgb-b}";
    color15 = "${base07-rgb-r}, ${base07-rgb-g}, ${base07-rgb-b}";
  };

  colorSchemeName = "${cfg.profileName}";

  profileText = ''
    [Appearance]
    AntiAliasFonts=true
    Blur=${boolToString cfg.blur}
    ColorScheme=${colorSchemeName}
    Font=${fontSpec cfg.fontFamily cfg.fontSize}
    HistoryMode=2
    HistorySize=10000
    TerminalMargin=${toString cfg.padding}
    UseTransparency=true
    Transparency=${floatToString cfg.opacity}

    [General]
    Name=${cfg.profileName}
    Parent=FALLBACK/
  '';

  colorSchemeText = ''
    [Background]
    Color=${modernPalette.background}
    Opacity=${floatToString cfg.opacity}

    [BackgroundIntense]
    Color=${modernPalette.backgroundIntense}
    Opacity=${floatToString cfg.opacity}

    [Color0]
    Color=${modernPalette.color0}

    [Color0Intense]
    Color=${modernPalette.color8}

    [Color1]
    Color=${modernPalette.color1}

    [Color1Intense]
    Color=${modernPalette.color9}

    [Color2]
    Color=${modernPalette.color2}

    [Color2Intense]
    Color=${modernPalette.color10}

    [Color3]
    Color=${modernPalette.color3}

    [Color3Intense]
    Color=${modernPalette.color11}

    [Color4]
    Color=${modernPalette.color4}

    [Color4Intense]
    Color=${modernPalette.color12}

    [Color5]
    Color=${modernPalette.color5}

    [Color5Intense]
    Color=${modernPalette.color13}

    [Color6]
    Color=${modernPalette.color6}

    [Color6Intense]
    Color=${modernPalette.color14}

    [Color7]
    Color=${modernPalette.color7}

    [Color7Intense]
    Color=${modernPalette.color15}

    [Foreground]
    Color=${modernPalette.foreground}

    [ForegroundIntense]
    Color=${modernPalette.foregroundIntense}

    [General]
    Description=${cfg.profileName}
    Blur=${boolToString cfg.blur}
    Opacity=${floatToString cfg.opacity}
    ${lib.optionalString cfg.wallpaper.enable "    Wallpaper=${self}/resources/images/wallpapers/${cfg.wallpaper.path}\n"}

    [Cursor]
    Color=${modernPalette.cursor}

    [Selection]
    Color=${modernPalette.selection}
  '';

  konsolercText = ''
    [Desktop Entry]
    DefaultProfile=${cfg.profileName}.profile

    [General]
    ConfigVersion=1

    [UiSettings]
    ColorScheme=${colorSchemeName}
  '';
in
{
  options.konsole = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "levente";
      description = "Home-Manager user to install Konsole profile for.";
    };

    profileName = lib.mkOption {
      type = lib.types.str;
      default = "Glass";
      description = "Profile name shown by Konsole.";
    };

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "FiraCode Nerd Font";
      description = "Font used inside Konsole.";
    };

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 11;
      description = "Font size for the Konsole profile.";
    };

    opacity = lib.mkOption {
      type = lib.types.float;
      default = 0.88;
      description = "Background opacity for the profile (0.0 – 1.0).";
    };

    blur = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable KDE blur-behind effect for the Konsole window.";
    };

    padding = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Inner padding around the terminal content.";
    };

    wallpaper = lib.mkOption {
      description = "Optional wallpaper for Konsole (from resources/images/wallpapers).";
      default = {
        enable = false;
        path = "fever_dream.png";
      };
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable wallpaper behind the terminal.";
          };
          path = lib.mkOption {
            type = lib.types.str;
            default = "fever_dream.png";
            description = "Filename under resources/images/wallpapers to use as wallpaper.";
          };
        };
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs; [ kdePackages.konsole ];

    home-manager.users."${cfg.user}" = {
      xdg.configFile."konsolerc".text = konsolercText;

      xdg.dataFile."konsole/${cfg.profileName}.profile".text = profileText;

      xdg.dataFile."konsole/${colorSchemeName}.colorscheme".text = colorSchemeText;
    };
  };
}
