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
        };

        accounts = {
            # specify the account name as the key
            levente.passwordFile = "/run/keys/copyparty/levente_password";
        };

        groups = {
            owner = [ "levente" ];
        };

        volumes = {
            # create a volume at "/" (the webroot), which will
            "/" = {
            # share the contents of "/srv/copyparty"
            path = "/srv/copyparty";
            # see `copyparty --help-accounts` for available options
            access = {
                # r = "*";
                rw = [ "levente" ];
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