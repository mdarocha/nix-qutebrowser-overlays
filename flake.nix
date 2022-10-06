{
  description = "qutebrowser with PR 4602 applied, adding support for tree-style tabs";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: {
    overlays.default = final: prev: {
      qutebrowser-with-treetabs = prev.qutebrowser.overrideAttrs (old: {
        name = "qutebrowser-with-treetabs-${old.version}";
        patches = (old.patches or [ ]) ++ [ ./treetabs.patch ];
      });
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    packages.x86_64-linux =
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ self.overlays.default ];
        };
      in
      { inherit (pkgs) qutebrowser-with-treetabs; };
  };
}
