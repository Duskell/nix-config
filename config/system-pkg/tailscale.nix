{ config, pkgs, lib, ... }:

let
  cfg = config.tail;
  shortFlags = lib.concatStringsSep " " (map (arg: "-${arg}") cfg.args);
  longFlags = lib.concatStringsSep " " (map (flag: "--${flag}") cfg.flags);
in
{ # Partly from a random blog on the tailscale site: https://tailscale.com/blog/nixos-minecraft
  options.tail = {
    args = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Arguments to be used in the tailscale up command, authkey is default";
    };
    flags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Flags to be used in the tailscale up command";
    };
  };
 
  config = {
    environment.systemPackages = with pkgs; [
     tailscale
    ];

    services.tailscale = {
      enable = true;
      useRoutingFeatures = "server";
    };

    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      # set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # have the job run this shell script
      script = with pkgs; ''
        set -euo pipefail

        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
        fi

        # otherwise authenticate with tailscale
        key="$(${coreutils}/bin/cat ${config.age.secrets.tailscale-key.path})"
        ${tailscale}/bin/tailscale up -authkey "$key"${lib.optionalString (shortFlags != "") " ${shortFlags}"}${lib.optionalString (longFlags != "") " ${longFlags}"}
      '';
    };
  };
}
