@_default:
    just --list

# activate NixOS config for host
activate HOSTNAME="localhost":
    nix run .#activate {{HOSTNAME}}

# update primary Flake inputs
update:
    nix run .#update

# format project files
fmt:
    nix fmt

# check Flake outputs
check:
    nix flake check
