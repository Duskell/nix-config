{ config, pkgs, lib, ... }:

let
  cfg = config.podman;
in
{
  options.podman = {
    styx = lib.mkOption {
      description = "Basically all my wp sites in one container";
      default = {};
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable this podman container.";
          };
          autoStart = lib.mkOption { # Not yet implemented
            type = lib.types.bool;
            default = false;
            description = "Start the container automatically.";
          };
          root = lib.mkOption {
            type = lib.types.path;
            default = ./containers;
            description = "Root directory for this container's files.";
          };
          volumes = lib.mkOption {
            type = lib.types.listOf (lib.types.submodule {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  description = "Name of the Podman volume.";
                };

                path = lib.mkOption {
                  type = lib.types.str;
                  description = "Relative path inside the repo for the bind mount.";
                };
              };
            });
            default = [];
            description = "List of container volumes.";
          };
        };
      };
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      podman
      podman-compose
    ];

    systemd.services = {
      podman-volumes = {
        description = "Ensures named volumes exist";
        after = [ "network.target" ];
        serviceConfig.ExecStart = lib.concatLists [
          (lib.optional cfg.styx.enable (
            lib.concatLists (map (vol: [
              ''
                ${pkgs.podman}/bin/podman volume create \
                  --name ${vol.name} \
                  --opt type=none \
                  --opt device=${cfg.styx.root}/${vol.name} \
                  --opt o=bind || true
              ''
            ]) cfg.styx.volumes)
          ))
        ];
      };

      podman-containers = {
        description = "Fetches the actual container";
        after = [ "network.target" ];
        serviceConfig.ExecStart = lib.concatLists [
          (lib.optional cfg.styx.enable ''
            test -d ${cfg.styx.root} || git clone git@github.com:Duskell/styx.git ${cfg.styx.root}
            git -C ${cfg.styx.root} pull
          '')
        ];
      };
    };


  };
}
