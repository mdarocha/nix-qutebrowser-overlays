{
  description = "qutebrowser with PR 4602 applied, adding support for tree-style tabs";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      qutebrowser = nixpkgs.legacyPackages.x86_64-linux.qutebrowser;
      qutebrowser-with-treetabs = qutebrowser.overrideAttrs (old: {
        name = "qutebrowser-with-treetabs";
        patches = (old.patches or [ ]) ++ [ ./treetabs.patch ];
      });
    in {
      packages.x86_64-linux.qutebrowser-with-treetabs = qutebrowser-with-treetabs;
      defaultPackage.x86_64-linux = qutebrowser-with-treetabs;
    };
}
