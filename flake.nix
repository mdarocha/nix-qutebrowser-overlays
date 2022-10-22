{
  description = "qutebrowser with PR 4602 applied, adding support for tree-style tabs";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: {
    overlays.default = final: prev: {
      qutebrowser-with-treetabs = prev.qutebrowser.overrideAttrs (old: rec {
        name = "${pname}-${old.version}";
        pname = "qutebrowser-with-treetabs";

        patches = (old.patches or [ ]) ++ [ ./treetabs.patch ];
      });

      qutebrowser-qt-6 = prev.qutebrowser-qt6.overrideAttrs (old: rec {
        name = "${pname}-${old.version}";
        pname = "qutebrowser-qt-6";
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
      { inherit (pkgs) qutebrowser-with-treetabs qutebrowser-qt-6; };
  };
}
