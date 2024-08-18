{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.atlas.development;
in

{
  options = {
    atlas.development = {
      enable = lib.mkEnableOption "Enable Atlas development tools";
    };
  };

  config = lib.mkIf cfg.enable {
    atlas.home.homeManagerModules = [
      {
        programs.bash = {
          enable = true;
          initExtra = ''
            source $HOME/.profile
          '';
        };

        programs.git = {
          enable = true;
          userName = config.atlas.me.fullName;
          userEmail = config.atlas.me.email;
          ignores = [ ".direnv" ];
          difftastic.enable = true;
        };

        programs.ssh = {
          enable = true;

          extraConfig = ''
            AddKeysToAgent yes
          '';

          matchBlocks = {
            "radagast" = {
              host = "radagast radagast.joshkingsley.me";
              forwardAgent = true;
            };
          };
        };

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        home.packages = with pkgs; [
          nodejs
          jdk

          clojure
          clojure-lsp
          clj-kondo

          vscode
        ];

        xdg.configFile."clojure/deps.edn".source = ./clojure/deps.edn;
      }
    ];
  };
}
