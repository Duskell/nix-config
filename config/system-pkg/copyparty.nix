{ config, pkgs, lib, ... }:

{
    environment.systemPackages = [ pkgs.copyparty ];

    services.copyparty = {
        enable = true;
        user = "copyparty"; 
        group = "copyparty"; 
        # directly maps to values in the [global] section of the copyparty config.
        # see `copyparty --help` for available options
        settings = {
            i = "0.0.0.0"; #ip
            p = [ 3210 ]; # ports
            # use booleans to set binary flags
            no-reload = true;
            shr = "/public";
        };

        accounts = {
            # specify the account name as the key
            levente.passwordFile = "/var/lib/copyparty/levente_password";

            attila.passwordFile = "/var/lib/copyparty/attila_password";
        };

        groups = {
            owner = [ "levente" ];
            users = [ "attila" ];
        };

        volumes = {
            "/" = {
            path = "/srv/copyparty/private";
            # see `copyparty --help-accounts` for available options
            access = {
                # r = "*";
                rwmd = [ "levente" "attila" ];
                rw = [ "attila" ];
            };
            # see `copyparty --help-flags` for available options
            flags = {
                # "fk" enables filekeys (necessary for upget permission) (4 chars long)
                fk = 4;
                # scan for new files every 60sec
                scan = 60;
                # volflag "e2d" enables the uploads database
                e2d = true;
                # "d2t" disables multimedia parsers (in case the uploads are malicious)
                d2t = true;
                # skips hashing file contents if path matches *.iso
                nohash = "\.iso$";
            };
            };

            "/public" = {
            path = "/srv/copyparty/public";
            # see `copyparty --help-accounts` for available options
            access = {
                # r = "*";
                rwmd = [ "levente" "attila" ];
                r = [ "attila" ];
            };
            # see `copyparty --help-flags` for available options
            flags = {
                # "fk" enables filekeys (necessary for upget permission) (4 chars long)
                fk = 4;
                # scan for new files every 60sec
                scan = 60;
                # volflag "e2d" enables the uploads database
                e2d = true;
                # "d2t" disables multimedia parsers (in case the uploads are malicious)
                d2t = true;
                # skips hashing file contents if path matches *.iso
                nohash = "\.iso$";
            };
            };
        };
        # you may increase the open file limit for the process
        openFilesLimit = 8192;
    };
}