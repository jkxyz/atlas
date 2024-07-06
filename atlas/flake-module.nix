{ self, ... }:

{
  flake = {
    nixosModules.atlas = {
      imports = [
        ./atlas
        ./nix
        ./home
        ./emacs
        ./desktop
        ./safenet
        ./development
      ];
    };
  };
}
