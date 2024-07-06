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
    atlas.home.extraHomeManagerOptions = {
      home.packages = with pkgs; [ ripgrep ];

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
    };
  };
}
