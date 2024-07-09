{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.atlas.emacs;
in

{
  options = {
    atlas.emacs = {
      enable = lib.mkEnableOption "Enable Atlas Emacs configuration";
    };
  };

  config = lib.mkIf cfg.enable { atlas.home.homeManagerModules = [ ./home.nix ]; };
}
