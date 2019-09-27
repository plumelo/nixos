self: super:
with super;
let alacritty = callPackage ./unwrapped.nix { };
in {
  alacritty = symlinkJoin {
    name = "alacritty-with-config-${alacritty.version}";

    paths = [ alacritty ];
    nativeBuildInputs = [ makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/alacritty \
        --add-flags "--config-file ${./config}" \
    '';

    passthru.terminfo = alacritty.terminfo;
  };

}
