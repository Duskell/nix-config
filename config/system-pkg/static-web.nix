{ config, pkgs, ... }:

{
    services.static-web-server = {
        enable = true;
        root = "/srv/streber";
        listen = "0.0.0.0:3578";
        configuration = {
        };
    };
}