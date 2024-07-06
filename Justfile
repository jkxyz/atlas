@_default:
    just --list

# activate NixOS config for current host
activate:
    nix run .#activate

# update primary Flake inputs
update:
    nix run .#update

# format project files
fmt:
    nix fmt
