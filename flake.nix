{
  description = "qutebrowser with PR 4602 applied, adding support for tree-style tabs";

  outputs = { self }: {
    overlay = self: super: {
      qutebrowser-with-treetabs = super.qutebrowser.overrideAttrs (old: {
        name = "qutebrowser-with-treetabs";
        patches = (old.patches or [ ]) ++ [ ./treetabs.patch ];
      });
    };
  };
}
