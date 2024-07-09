{
  flake,
  config,
  lib,
  pkgs,
  ...
}:

{
  home.sessionVariables = {
    EMACSDIR = "${config.xdg.configHome}/emacs";
    DOOMDIR = "${config.xdg.configHome}/doom";
    DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
    DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
  };

  home.sessionPath = [ "${config.home.sessionVariables.EMACSDIR}/bin" ];

  home.packages = with pkgs; [
    ripgrep
    fd
    nixfmt-rfc-style
    editorconfig-core-c
    fira-code
    pandoc
    gcc
    binutils
    pamixer
    cmake
    gnumake
    nodePackages.prettier
    tailwindcss-language-server
    rustywind

    # Python
    python3
    poetry
    black
    isort
    pyright
    python311Packages.pyflakes
  ];

  xdg.configFile."emacs" = {
    source = flake.inputs.doomemacs;
    # TODO Could run doom sync with onChange
  };

  xdg.configFile."doom" = {
    source = ./doom;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: with epkgs; [ vterm ];
  };

  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
    startWithUserSession = "graphical";
  };

  systemd.user.services.emacs.Service.Restart = lib.mkForce "always";
}
