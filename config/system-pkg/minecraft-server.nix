{ config, pkgs, lib, nix-minecraft, ... }:

{
  imports = [ nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      modded = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_5.override { loaderVersion = "0.17.2"; };

        jvmOpts = "-Xms2G -Xmx6G";

        operators =  {
          TopMagyar = {
            uuid = "08b1d6a5-32b7-3a1d-8f87-203cc22460b9";
            bypassesPlayerLimit = true;
            level = 4;
          };
        };

        serverProperties = {
          server-port = 25565;
          difficulty = 2;
          gamemode = 1;
          max-players = 5;
          motd = "Self hosting fuck yeaaah!";
          management-server-enabled = true;
          management-server-port = 25566;
          allow-cheats = true;
          online-mode = false;
          enable-rcon = true;
          "rcon.password" = "Atlanti9956";
          spawn-protection = 0;
          allow-flight = true;
        };

        symlinks =
        let
          modpack = ( pkgs.fetchPackwizModpack {
            url = "https://raw.githubusercontent.com/Duskell/mc-server/refs/heads/main/pack.toml";
            packHash = "Bii9Lig24o7kVmBQ/punhgu6CwJUuqmLkgT8Bf6sa58=";
          });
        in
        {
          "mods" = "${modpack}/mods";
        };
      };
    };
  };

  users.users.minecraft.home = lib.mkForce "/srv/minecraft";
}
