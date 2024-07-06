{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.atlas.emacs;

  emacsWithPackages = (pkgs.emacsPackagesFor pkgs.emacs29-pgtk).emacsWithPackages (
    epkgs: with epkgs; [ vterm ]
  );
in

{
  options = {
    atlas.emacs = {
      enable = lib.mkEnableOption "Enable Atlas Emacs configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    atlas.home.homeManagerModules = [
      {
        home.packages = with pkgs; [
          ripgrep
          fd
          nixfmt-rfc-style
          editorconfig-core-c
          fira-code
          pandoc
          gcc
          binutils
          pamixer
          cmake
          gnumake
          nodePackages.prettier
          tailwindcss-language-server
          rustywind

          # Python
          python3
          poetry
          black
          isort
          pyright
          python311Packages.pyflakes
        ];

        home.sessionPath = [ "$HOME/.config/emacs/bin" ];

        programs.emacs = {
          enable = true;
          package = emacsWithPackages;
        };

        services.emacs = {
          enable = true;
          package = emacsWithPackages;
          client.enable = true;
          defaultEditor = true;
          startWithUserSession = "graphical";
        };

        systemd.user.services.emacs.Service.Restart = lib.mkForce "always";

        xdg.configFile."doom".source = ./doom;
      }
    ];
  };
}
