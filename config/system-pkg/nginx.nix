{
  config,
  pkgs,
  lib,
  ...
}: {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    clientMaxBodySize = "1000m";

    commonHttpConfig = let
      realIpsFromList = lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
      fileToList = x: lib.strings.splitString "\n" (builtins.readFile x);
      cfipv4 = fileToList (pkgs.fetchurl {
        url = "https://www.cloudflare.com/ips-v4";
        sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
      });
      cfipv6 = fileToList (pkgs.fetchurl {
        url = "https://www.cloudflare.com/ips-v6";
        sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
      });
    in ''
      ${realIpsFromList cfipv4}
      ${realIpsFromList cfipv6}
      real_ip_header CF-Connecting-IP;
    '';

    virtualHosts."api.juhaszlevente.hu" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9090";
        proxyWebsockets = true;
        extraConfig =
          # required when the target is also TLS server with multiple hosts
          "proxy_ssl_server_name on;"
          +
          # required when the server wants to use HTTP Authentication
          "proxy_pass_header Authorization;";
      };
      locations = {
        "/myadmin" = {
          proxyPass = "http://localhost:9091";
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
    };
    virtualHosts."cparty.juhaszlevente.hu" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3200";
        proxyWebsockets = true;
        extraConfig =
          "proxy_ssl_server_name on;"
          + "proxy_pass_header Authorization;";
      };
    };
    virtualHosts."streber.juhaszlevente.hu" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3578";
        extraConfig = "proxy_ssl_server_name on;";
      };
    };

    virtualHosts."partner.juhaszlevente.hu" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7070";
        extraConfig = ''
          proxy_ssl_server_name on;
          proxy_pass_header Authorization;
        '';
      };
    };

    virtualHosts."pb.juhaszlevente.hu" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:6060";
        extraConfig = ''
          proxy_ssl_server_name on;
          proxy_pass_header Authorization;
        '';
      };
    };
  };
}
