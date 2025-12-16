{
  description = "NixOS config i guess";

  inputs = {
    agenix.url = "github:ryantm/agenix";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #nur = {
    #  url = "github:nix-community/NUR";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    copyparty.url = "github:9001/copyparty";

    nixcord.url = "github:kaylorben/nixcord";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    agenix,
    nix-minecraft,
    copyparty,
    stylix,
    nixcord,
    rust-overlay,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {inherit system;};

    lib = nixpkgs.lib;

    configSettings = [
      agenix.nixosModules.default
      ./config/pkgs/core.nix
      ./config/shared.nix
      ./config/secrets.nix
      ./config/networking.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.overwriteBackup = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit nixcord self;
        };
      }

      ({pkgs, ...}: {
        environment.systemPackages = [
          self.packages.${system}.scripts
          agenix.packages.x86_64-linux.default
        ];
      })
    ];
  in {
    overlays.default = final: prev: {
      plymouth-themes = args:
        import ./config/system-pkg/plymouth-theme-importer/package.nix ({
            stdenv = prev.stdenv;
            fetchurl = prev.fetchurl;
            lib = prev.lib;
            unzip = prev.unzip;
          }
          // args);

      vesktop = prev.vesktop.overrideAttrs (old: let
        filterOutObsoletePatch = patch:
          builtins.match ".*use_system_vencord\\.patch$" (builtins.toString patch) == null;
        patchesWithoutObsolete = prev.lib.filter filterOutObsoletePatch (old.patches or []);
        useSystemVencordPatch = prev.replaceVars ./patches/vesktop-use-system-vencord.patch {
          vencord = builtins.toString prev.vencord;
        };
      in {
        patches = patchesWithoutObsolete ++ [useSystemVencordPatch];
      });
    };

    packages.${system} = {
      scripts = pkgs.stdenv.mkDerivation {
        name = "all-scripts";
        src = ./scripts;

        installPhase = ''
          mkdir -p $out/bin
          shopt -s nullglob
          for f in $src/*; do
            install -m755 "$f" "$out/bin"
          done
        '';
      };
    };

    nixosConfigurations = {
      hp = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit stylix nixcord self;
          system = "x86_64-linux";
        };
        modules =
          configSettings
          ++ [
            ./config/grub/desktop_grub.nix
            ./config/pkgs/ui.nix
            ./config/secrets.nix
            ./hosts/hp/configuration.nix
            ./hosts/hp/hardware-configuration.nix

            ({pkgs, ...}: {
              nixpkgs.overlays = [
                self.overlays.default
                rust-overlay.overlays.default
              ];

              environment.systemPackages = [pkgs.rust-bin.stable.latest.default];

              home-manager.users.levente.imports = [
                ./hosts/hp/home.nix
                ./config/pkgs/dev-home.nix
                ./config/pkgs/game-home.nix
              ];
            })
          ];
      };

      server = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit stylix self nix-minecraft;};
        modules =
          configSettings
          ++ [
            copyparty.nixosModules.default
            ./config/grub/headless_grub.nix
            ./config/pkgs/server.nix
            ./hosts/server/configuration.nix
            ./hosts/server/hardware-configuration.nix

            ({pkgs, ...}: {
              home-manager.users.levente.imports = [
                ./hosts/server/home.nix
              ];
              nixpkgs.overlays = [copyparty.overlays.default];
            })
          ];
      };
    };
  };
}
