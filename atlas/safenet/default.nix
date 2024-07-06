{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.atlas.safenet;
in

{
  options = {
    atlas.safenet = {
      enable = lib.mkEnableOption "Enable Safenet smartcard token integration";
    };
  };

  config = lib.mkIf cfg.enable {
    services.pcscd = {
      enable = true;
      plugins = [ pkgs.pcsc-safenet ];
    };

    programs.firefox.wrapperConfig.smartcardSupport = true;
  };
}
