{ config, pkgs, lib, ... }:

let
  cfg = config.timers;
in
{
  options.timers = {
    goSleep = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable sleep timer";
          };
          schedule = lib.mkOption {
            type = lib.types.str;
            default = "*-*-* 00:00:00";
            description = "Sleep when";
          };
        };
      };
      default = {};
      description = "Sleep timer for the server";
    };

    wakeUp = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable wake up timer";
          };
          schedule = lib.mkOption {
            type = lib.types.str;
            default = "*-*-* 14:00:00";
            description = "Awake when";
          };
        };
      };
      default = {};
      description = "Wake up timer for the server";
    };
  };

  config = {
    systemd.services = {
      goSleep = lib.mkIf cfg.goSleep.enable {
        description = "Set server to sleep mode";
        script = "wakeUp";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };

      wakeUp = lib.mkIf cfg.wakeUp.enable {
        description = "Wake the system up";
        script = "wakeUp";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };

    systemd.timers = {
      goSleep = lib.mkIf cfg.goSleep.enable {
        description = "Set the system to sleep mode at schedule";
        timerConfig = {
          OnCalendar = cfg.goSleep.schedule;
          Persistent = true;
        };
        wantedBy = [ "timers.target" ];
      };

      wakeUp = lib.mkIf cfg.wakeUp.enable {
        description = "Wake the system up at schedule";
        timerConfig = {
          OnCalendar = cfg.wakeUp.schedule;
          Persistent = true;
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };
}
