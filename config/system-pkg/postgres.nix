{
  pkgs,
  lib,
  ...
}: { # FOR NOW ITS WIP
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;

    settings = {
      port = 11859;
      ssl = false;
    };

    ensureDatabases = ["gitea"];

    initialScript = pkgs.writeText "init-postgres-passwords" ''
      -- Set password for 'levente'
      ALTER ROLE "levente" WITH LOGIN PASSWORD 'SCRAM-SHA-256$4096:lB4tguN+gvNVSqk0zGRPHQ==$zh48o1bb9tuRjvGQHh/CeobEyUI4u91rp0K9who8m3I=:mHxc6obGad8/g65+V3C84UQGHIK41Gfx32+xXSZiOss=';

      -- Set password and ownership for 'gitea'
      ALTER ROLE "gitea" WITH LOGIN PASSWORD 'SCRAM-SHA-256$4096:KAHGMmQ3GTvFO5DzQnGrHw==$g1vuiZFMYmyP9Ku4nAsIWrqVmyWhRR1Pl0Sg+uVAz24=:TbBOohcQjoNzI3hsVbWnRSzDpYHi9nppxoacXygVeKw=';
    '';

    authentication = lib.mkOverride 10 ''
      local all       all     trust
      host  all    levente     127.0.0.1/32 scram-sha-256
      host  all    levente     ::1/128 scram-sha-256
      host  gitea    gitea     127.0.0.1/32 scram-sha-256
      host  gitea    gitea     ::1/128 scram-sha-256
    '';

    ensureUsers = [
      {
        name = "levente";
        ensureDBOwnership = false;
        ensureClauses = {};
      }
      {
        name = "gitea";
        ensureDBOwnership = true;
        ensureClauses = {};
      }
    ];
  };
}
