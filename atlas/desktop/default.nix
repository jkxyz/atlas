{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.atlas.desktop;
in

{
  options = {
    atlas.desktop = {
      enable = lib.mkEnableOption "Enable Atlas desktop configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    atlas.safenet.enable = true;

    programs.firefox.enable = true;

    atlas.home.homeManagerModules = [
      {
        home.packages = with pkgs; [
          keepassxc
          vlc
          slack
          libreoffice-qt
          thunderbird
          brave
          nextcloud-client
        ];

        services.nextcloud-client = {
          enable = true;
          startInBackground = true;
        };

        programs.chromium.enable = true;
      }
    ];
  };
}
