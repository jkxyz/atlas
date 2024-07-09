{ flake, self, ... }:

{
  imports = [
    flake.inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-intel
    flake.inputs.lanzaboote.nixosModules.lanzaboote
    flake.inputs.musnix.nixosModules.musnix
    flake.inputs.self.nixosModules.atlas
    ./hardware-configuration.nix
    ./legacy.nix
  ];

  system.stateVersion = "21.05";

  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  atlas.home.enable = true;
  atlas.emacs.enable = true;
  atlas.desktop.enable = true;
  atlas.development.enable = true;
}
