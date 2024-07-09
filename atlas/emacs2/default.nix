{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.atlas.emacs2;

  emacsWithPackages = (pkgs.emacsPackagesFor pkgs.emacs29-pgtk).emacsWithPackages (
    epkgs: with epkgs; [
      evil
      evil-collection
      vterm
      doom-themes
      treesit-grammars.with-all-grammars
      nix-ts-mode
      corfu
      editorconfig
      apheleia
      lsp-mode
      which-key
      lsp-tailwindcss
      cider
      clojure-ts-mode
      smartparens
      evil-cleverparens

      pkgs.nodePackages_latest.typescript
      pkgs.tailwindcss-language-server
    ]
  );

  atlasemacs = pkgs.writers.writeBashBin "atlasemacs" ''
    exec ${emacsWithPackages}/bin/emacs --init-directory=$XDG_CONFIG_HOME/atlasemacs
  '';
in

{
  options = {
    atlas.emacs2 = {
      enable = lib.mkEnableOption "Enable Atlas Emacs";
    };
  };

  config = lib.mkIf cfg.enable {
    atlas.home.homeManagerModules = [
      {
        home.packages = with pkgs; [ atlasemacs ];

        xdg.configFile."atlasemacs".source = ./config;
      }
    ];
  };
}
