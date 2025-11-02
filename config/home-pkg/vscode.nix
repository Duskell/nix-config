{ condfig, pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default.userSettings = {
      "workbench.colorTheme" = "Thanatos";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.fontFamily" = "JetBrains Mono";
      "editor.fontLigatures" = true;
    };

    profiles.default.extensions = with pkgs.vscode-extensions; [
      pkief.material-icon-theme
      ecmel.vscode-html-css
      ms-dotnettools.csharp
      ms-dotnettools.vscodeintellicode-csharp
      ritwickdey.liveserver
      ms-python.python
      mechatroner.rainbow-csv
      visualstudiotoolsforunity.vstuc
      bbenoist.nix
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "theme-easy-eyes";
        publisher = "vvhg1";
        version = "1.2.1";
        hash = "sha256-t1ZAypr077IqJqA3mLgRgleqY/Q74VOkyrHjDvs/Bo8=";
      }
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "nix-extension-pack";
        publisher = "pinage404";
        version = "3.0.0";
        hash = "sha256-cWXd6AlyxBroZF+cXZzzWZbYPDuOqwCZIK67cEP5sNk=";
      }
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "better-nix-syntax";
        publisher = "jeff-hykin";
        version = "2.3.0";
        hash = "sha256-Zb4RFs2qkSMeQKkNXk4brrZBDiRK4e08taOOgdRWQEk=";
      }
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "nix";
        publisher = "alvarosannas";
        version = "1.4.8";
        hash = "sha256-6ymqo2qOZolehS+AN4j8LM8Ksdt3Jux3GmNz+FYjkpw=";
      }
    ];

  };
}
