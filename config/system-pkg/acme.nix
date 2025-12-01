{config, ...}: let
  domainName = "juhaszlevente.hu";
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = "duskell@proton.me";
    # certs = {
    #   "${domainName}" = {
    #     reloadServices = [ "nginx" ];
    #     listenHTTP = ":80";
    #     # EC is not supported by SWS versions before 2.16.1
    #     keyType = "rsa4096";
    #     group = config.services.nginx.group;
    #     extraDomainNames = [
    #       "cparty.${domainName}"
    #       "api.${domainName}"
    #       "streber.${domainName}"
    #       "www.${domainName}"
    #     ];
    #   };
    # };
  };
}
