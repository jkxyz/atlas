{ self, inputs, ... }:

{
  flake = {
    nixosModules.atlas = {
      imports = [
        inputs.nix-index-database.nixosModules.nix-index

        ./people
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
