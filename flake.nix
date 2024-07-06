{
  description = "Atlas Nix operating system";

  inputs = {
    # # Primary Inputs
    # Update with `nix run .#update`

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # # Flake Modules

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nixos-flake.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = [ "x86_64-linux" ];

      perSystem =
        { config
        , self'
        , inputs'
        , pkgs
        , system
        , ...
        }:
        {
          # Flake inputs to be updated periodically
          # To update, run `nix run .#update`
          nixos-flake.primary-inputs = [
            "nixpkgs"
            "home-manager"
          ];

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixpkgs-fmt.enable = true;
          };

          devShells.default = pkgs.mkShell { packages = with pkgs; [ just ]; };
        };

      flake = {
        nixosConfigurations.sparrowhawk = self.nixos-flake.lib.mkLinuxSystem ./systems/sparrowhawk;
      };
    };
}
