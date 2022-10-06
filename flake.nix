{
  description = "qutebrowser with PR 4602 applied, adding support for tree-style tabs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-pyqt6.url = "github:LunNova/nixpkgs/lunnova/cura-upgrade";
  };

  outputs = { self, nixpkgs, nixpkgs-pyqt6 }: {
    overlays.default = final: prev: {
      qutebrowser-with-treetabs = prev.qutebrowser.overrideAttrs (old: rec {
        name = "${pname}-${old.version}";
        pname = "qutebrowser-with-treetabs";

        patches = (old.patches or [ ]) ++ [ ./treetabs.patch ];
      });

      qutebrowser-qt-6 = prev.qutebrowser.overrideAttrs (old: let
        pyqt6 = nixpkgs-pyqt6.legacyPackages.${prev.system}.python3.pkgs.pyqt6;
      in rec {
        name = "${pname}-${version}";
        pname = "qutebrowser-qt-6";
        version = "unstable-06-10-22";

        src = prev.runCommand "${name}-tarball"
          {
            src = prev.fetchFromGitHub {
              owner = "qutebrowser";
              repo = "qutebrowser";
              rev = "5e11e6c7d413cf5c77056ba871a545aae1cfd66a";
              sha256 = "sha256-5HNzPO07lUQe/Q3Nb4JiS9kb9GMQ5/FqM5029vLNNWo=";
            };
            binPath = prev.lib.makeBinPath [ prev.python3 ];
            PYTHONPATH = "${pyqt6}";
          } ''
          export PATH="$binPath:$PATH"
          python3 $src/scripts/dev/build_release.py --skip-packaging
        '';
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
