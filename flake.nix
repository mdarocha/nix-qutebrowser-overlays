{
  description = "qutebrowser with PR 4602 applied, adding support for tree-style tabs";

  outputs = { self }: {
    overlays.default = final: prev: {
      qutebrowser-with-treetabs = prev.qutebrowser.overrideAttrs (old: {
        name = "qutebrowser-with-treetabs";
        patches = (old.patches or [ ]) ++ [ ./treetabs.patch ];
      });
    };
  };
}
