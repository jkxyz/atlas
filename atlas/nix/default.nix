{ flake, ... }:

{
  nix = {
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ];

    # Use pinned nixpkgs for commands like `nix shell`
    registry.nixpkgs.flake = flake.inputs.nixpkgs;

    settings = {
      experimental-features = "nix-command flakes";
    };
  };
}
