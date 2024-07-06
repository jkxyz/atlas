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
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.nixos-flake.flakeModule ];

      systems = [ "x86_64-linux" ];

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          # Flake inputs to be updated periodically
          # To update, run `nix run .#update`
          nixos-flake.primary-inputs = [
            "nixpkgs"
            "home-manager"
          ];

          devShells.default = pkgs.mkShell { packages = with pkgs; [ just ]; };
        };

      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
