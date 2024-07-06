{ self, inputs, ... }:

{
  flake = {
    nixosModules.atlas = {
      imports = [
        inputs.nix-index-database.nixosModules.nix-index

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
