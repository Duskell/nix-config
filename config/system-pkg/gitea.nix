{
  config,
  pkgs,
  ...
}: {
  services.gitea = {
    enable = true;
    stateDir = "/var/lib/gitea";
    repositoryRoot = "/git";

    database = {
      user = "gitea";
      type = "postgres";
      name = "gitea";
    };

    settings = {
      service.DISABLE_REGISTRATION = true;
      server.STATIC_ROOT_PATH = "/var/lib/gitea/data";
    };
  };
}
