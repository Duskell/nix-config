{
  description = "NixOS config";

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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, agenix, nix-minecraft, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs { inherit system; };

    lib = nixpkgs.lib;

    configSettings = [
      agenix.nixosModules.default
      ./config/pkgs/core.nix
      ./config/shared.nix
      ./config/secrets.nix
      ./config/networking.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.overwriteBackup = true;
        home-manager.useUserPackages = true;
      }

      ({ pkgs, ... }: {
        environment.systemPackages = [ self.packages.${system}.scripts ];
      })
    ];

    in {
      packages.${system} = {
        kuro-the-cat = pkgs.stdenv.mkDerivation {
          pname = "kuro-the-cat";
          version = "1.0.0";
          src = ./resources/plymouth/kuro-the-cat;

          installPhase = ''
            mkdir -p $out/share/plymouth/themes/kuro-the-cat
            cp -r ./* $out/share/plymouth/themes/kuro-the-cat
          '';

          postInstall = ''
            find $out/share/plymouth/themes -name "*.plymouth" -exec \
              sed -i "s@/usr/@$out/@" {} \;
          '';

        };

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
          specialArgs = { inherit inputs; inherit self; };
          modules = configSettings ++ [
            ./config/grub/desktop_grub.nix
            ./config/pkgs/ui.nix
            ./config/secrets.nix
            ./hosts/hp/configuration.nix
            ./hosts/hp/hardware-configuration.nix

            ({ pkgs, ... }: {
              home-manager.users.levente.imports  = [
                ./hosts/hp/home.nix
                ./config/pkgs/dev-home.nix
                ./config/pkgs/game-home.nix
              ];
            })
          ];
        };

        server = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = configSettings ++ [
            ./config/grub/headless_grub.nix
            ./config/pkgs/server.nix
            ./hosts/server/configuration.nix
            ./hosts/server/hardware-configuration.nix

            ({ pkgs, ... }: {
              home-manager.users.levente.imports  = [
                ./hosts/server/home.nix
              ];
            })
          ];
        };
      };
    };
}
