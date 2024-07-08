{ lib, config, ... }:

let
  cfg = config.atlas;

  personOpts =
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = ''
            An identifier for the person. Must be valid username.
          '';
        };

        fullName = lib.mkOption {
          type = lib.types.str;
          description = ''
            Full name of the person.
          '';
        };

        email = lib.mkOption {
          type = lib.types.str;
          description = ''
            Email address used by the person.
          '';
        };

        sshKeys = lib.mkOption {
          type = lib.types.listOf lib.types.singleLineStr;
          default = [ ];
          description = ''
            SSH public keys owned by this person.
          '';
        };
      };
    };
in

{
  options = {
    atlas = {
      people = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule personOpts);
        description = ''
          Details about people referenced in this configuration.
        '';
      };

      me = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
        default = cfg.people.josh;
      };
    };
  };

  config = {
    atlas.people = import ./people.nix;

    users.users.${cfg.me.name}.isNormalUser = true;
  };
}
