{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.atlas.safenet;

  firefoxPolicy = {
    SecurityDevices = {
      Add = {
        "SafeNet" = "${pkgs.pcsc-safenet}/lib/libeToken.so";
      };
    };
  };
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

    programs.firefox.policies = firefoxPolicy;

    atlas.home.homeManagerModules = [ { programs.firefox.policies = firefoxPolicy; } ];
  };
}
