{config, ...}: let
  domainName = "juhaszlevente.hu";
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "duskell@proton.me";
    certs = {
      "${domainName}" = {
        group = config.services.nginx.group;
        extraDomainNames = [
          "cparty.${domainName}"
          "api.${domainName}"
          "streber.${domainName}"
          "www.${domainName}"
        ];
      };
    };
  };
}
