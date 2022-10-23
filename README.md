# nix-qutebrowser-overlays

A nix flake with overlays that add tree tabs in qutebrowser.

This package is built by applying a patch from [PR 4602](https://github.com/qutebrowser/qutebrowser/pull/4602)

## Usage

Example usage a flake (your usage may differ):

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    qutebrowser-overlays.url = "github:mdarocha/nix-qutebrowser-overlays";
  };

  outputs = inputs@{ nixpkgs }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      overlays = [
        inputs.qutebrowser-overlays.overlays.default
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

This makes two new packages available in `nixpkgs`:

- `qutebrowser-with-treetabs`, which is the current stable version of qutebrowser with tree tabs.

- `qutebrowser-qt6-with-treetabs`, which is a build of qutebrowser from the `qt6-v2` branch, with tree tabs patch applied.
