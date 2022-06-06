# nix-qutebrowser-with-treetabs
A nix flake with an overlay, adding a qutebrowser package with treetabs support.

This package is built by applying a (slightly modified, due to build problems) path from [PR 4602](https://github.com/qutebrowser/qutebrowser/pull/4602)

## Usage

Example usage a flake (your usage may differ):

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    qutebrowser-with-treetabs = {
      url = "github:mdarocha/nix-qutebrowser-with-treetabs";
    };
  };

  outputs = inputs@{ nixpkgs }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      overlays = [
        inputs.qutebrowser-with-treetabs.overlays.default
      ];
    in {
      nixosConfigurations.aNixosSystem = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          ({ nixpkgs, ... }: { nixpkgs.overlays = overlays; })
        ];
      };
    };
}
```
