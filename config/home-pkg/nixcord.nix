{ 
  config,
  pkgs,
  nixcord,
  ...
}:
{
  imports = [
    nixcord.homeModules.nixcord
  ];

  home.packages = with pkgs; [
    vesktop
  ];

  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;

    config = {
      plugins = {
        betterFolders.enable = true;
        betterRoleContext.enable = true;
        crashHandler.enable = true;
        memberCount.enable = true;
        mentionAvatars.enable = true;
        messageLatency.enable = true;
        showHiddenThings.enable = true;
        showMeYourName.enable = true;
        webContextMenus.enable = true;
        webKeybinds.enable = true;
        webScreenShareFixes.enable = true;
        alwaysAnimate.enable = true;
      };
    };

    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };
}