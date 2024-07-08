{
  flake,
  config,
  lib,
  ...
}:

let
  cfg = config.atlas.home;
in

{
  imports = [
    # home-manager module comes from nixos-flake
    flake.inputs.self.nixosModules.home-manager
  ];

  options = {
    atlas.home = {
      enable = lib.mkEnableOption "Enable Atlas Home Manager integration";

      user = lib.mkOption {
        type = lib.types.str;
        default = config.atlas.me.name;
        description = "The username to which the Atlas Home Manager options will apply.";
      };

      homeManagerModules = lib.mkOption {
        type = lib.types.listOf lib.types.deferredModule;
        default = [ ];
      };
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.homeManagerModules != [ ] -> cfg.enable;
          message = "Using an Atlas module with required Home Manager options, but `atlas.home.enable` is false";
        }
      ];
    }
    (lib.mkIf cfg.enable {
      home-manager.users.${cfg.user} = {
        imports = cfg.homeManagerModules;
        home.stateVersion = config.system.stateVersion;
        xdg.enable = true;
      };
    })
  ];
}
