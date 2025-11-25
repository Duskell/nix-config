{ config, pkgs, lib, self, ... }:

let
  cfg = config.dolphin;

  boolToString = value: if value then "true" else "false";

  intToString = value: builtins.toString value;

  palette = with config.lib.stylix.colors; {
    accent = "#${base0E}";
    background = "#${base00}";
    backgroundAlt = "#${base01}";
    foreground = "#${base05}";
  };

  dolphinrcText = ''
    [General]
    ConfirmCloseAllTabs=false
    ShowFullPath=true
    RememberOpenedTabs=false
    UseTabForSplitView=true

    [IconsMode]
    PreviewSize=48
    Sorting=1

    [UI]
    LocationBarKUrlCompletionMode=5
    UseEditableLocationBar=true

    [Panels]
    PlacesPanelOpacity=${intToString cfg.opacityPercent}
    PlacesPanelUseSystemColor=${boolToString false}

    [Colors]
    Foreground=${palette.foreground}
    Background=${palette.background}
    AlternateBackground=${palette.backgroundAlt}
    Highlight=${palette.accent}
    HighlightedText=${palette.background}
  '';
in
{
  options.dolphin = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "levente";
      description = "Home-Manager user to install Dolphin tweaks for.";
    };

    opacityPercent = lib.mkOption {
      type = lib.types.int;
      default = 88;
      description = "Opacity (0-100) applied via KWin rules for active/inactive Dolphin (and optionally Konsole) windows.";
    };

  };

  config = {
    environment.systemPackages = with pkgs; [ kdePackages.dolphin ];

    home-manager.users."${cfg.user}" = {
      xdg.configFile."dolphinrc".text = dolphinrcText;
    };
  };
}
