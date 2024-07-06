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

      extraHomeManagerOptions = lib.mkOption {
        type = lib.types.attrs;
        description = ''
          Options to be passed to the user's Home Manager configuration.
        '';
      };
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.extraHomeManagerOptions != null -> cfg.enable;
          message = "Using an Atlas module with required Home Manager options, but `atlas.home.enable` is false";
        }
      ];
    }
    (lib.mkIf cfg.enable {
      home-manager.users.${cfg.user} = lib.mkMerge [
        {
          home.stateVersion = config.system.stateVersion;
          xdg.enable = true;
        }
        cfg.extraHomeManagerOptions
      ];
    })
  ];
}
