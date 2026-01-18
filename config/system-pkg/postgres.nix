{pkgs, ...}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    port = 11859;
    settings = {
      ssl = false;
    };
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host  all    levente     127.0.0.1/32 scram-sha-256
      host  all    levente     ::1/128 scram-sha-256
      host  gitea    gitea     127.0.0.1/32 scram-sha-256
      host  gitea    gitea     ::1/128 scram-sha-256
    '';
    ensureUsers = [
      {
        name = "levente";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
          password = "SCRAM-SHA-256$4096:lB4tguN+gvNVSqk0zGRPHQ==$zh48o1bb9tuRjvGQHh/CeobEyUI4u91rp0K9who8m3I=:mHxc6obGad8/g65+V3C84UQGHIK41Gfx32+xXSZiOss=";
        };
      }
      {
        name = "gitea";
        ensureDBOwnership = true;
        ensureDatabases = ["gitea"];
        ensureClauses = {
          login = true;
          password = "SCRAM-SHA-256$4096:KAHGMmQ3GTvFO5DzQnGrHw==$g1vuiZFMYmyP9Ku4nAsIWrqVmyWhRR1Pl0Sg+uVAz24=:TbBOohcQjoNzI3hsVbWnRSzDpYHi9nppxoacXygVeKw=";
        };
      }
    ];
  };
}
