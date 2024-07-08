{
  description = "Atlas Nix operating system";

  inputs = {
    # Primary Inputs - update with `just update`

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    musnix.url = "github:musnix/musnix";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Development

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-flake.url = "github:srid/nixos-flake";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nixos-flake.flakeModule
        inputs.treefmt-nix.flakeModule
        ./atlas/flake-module.nix
      ];

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
          nixos-flake.primary-inputs = [
            "nixpkgs"
            "home-manager"
            "nixos-hardware"
            "lanzaboote"
            "musnix"
            "nix-index-database"
          ];

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
          };

          devShells.default = pkgs.mkShell { packages = with pkgs; [ just ]; };
        };

      flake = {
        # ThinkPad E14 Intel laptop, primary work machine
        nixosConfigurations.sparrowhawk = self.nixos-flake.lib.mkLinuxSystem ./systems/sparrowhawk;

        # 2017 MacBook Pro, home server
        nixosConfigurations.radagast = self.nixos-flake.lib.mkLinuxSystem ./systems/radagast;
      };
    };
}
