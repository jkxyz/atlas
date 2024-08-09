{
  config,
  pkgs,
  lib,
  ...
}:

{
  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://devenv.cachix.org"
  ];

  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.bootspec.enable = true;

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.initrd.systemd.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sparrowhawk";

  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [ "all" ];

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.josh = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "scanner"
      "lp"
      "vboxusers"
      "audio"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    pavucontrol
    unzip
    zip
    qpwgraph
    appimage-run
    pciutils
    kdePackages.qtmultimedia
    kdePackages.qtwebengine
    kdePackages.kdialog
    kdePackages.filelight
    kdePackages.partitionmanager
    sbctl
  ];

  hardware.bluetooth.enable = true;

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;

  services.tailscale.enable = true;

  networking.firewall.checkReversePath = "loose";

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  programs.kdeconnect.enable = true;

  services.flatpak.enable = true;

  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };

  services.fwupd.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  virtualisation.virtualbox.host.enable = true;

  programs.nix-index.enable = true;
  programs.nix-index.enableBashIntegration = true;
  programs.command-not-found.enable = false;

  # Required for SafeNet
  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

  musnix.enable = true;

  # TODO Enable tlp

}
