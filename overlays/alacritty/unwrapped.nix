{ stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  makeWrapper,
  ncurses,
  expat,
  pkgconfig,
  freetype,
  fontconfig,
  libX11,
  gzip,
  libXcursor,
  libXxf86vm,
  libXi,
  libXrandr,
  libGL,
  xclip,
  wayland,
  libxkbcommon,
}:

with rustPlatform;

let
  rpathLibs = [
    expat
    freetype
    fontconfig
    libX11
    libXcursor
    libXxf86vm
    libXrandr
    libGL
    libXi
    wayland
    libxkbcommon
  ];
in buildRustPackage rec {
  pname = "alacritty";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = pname;
    rev = "9c6d12ea2c863ba76015bdedc00db13b7307725a";
    sha256 = "1ljfdnkwica7l6m1w0s7vqkq6p642q7nhw14ja4k6vbnfbbkn8xh";
  };

  cargoSha256 = "1nwhmyikhzrkzyvxv25rbg8xmch4j7y25h3s95lsrrzj5kkdna5z";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkgconfig
    ncurses
    gzip
  ];

  buildInputs = rpathLibs;

  outputs = [ "out" "terminfo" ];

  postPatch = ''
    substituteInPlace copypasta/src/x11.rs \
      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
  '';

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty

    install -D extra/linux/alacritty.desktop -t $out/share/applications/
    install -D extra/logo/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty

    install -D extra/completions/_alacritty -t "$out/share/zsh/site-functions/"
    install -D extra/completions/alacritty.bash -t "$out/etc/bash_completion.d/"
    install -D extra/completions/alacritty.fish -t "$out/share/fish/vendor_completions.d/"

    install -dm 755 "$out/share/man/man1"
    gzip -c extra/alacritty.man > "$out/share/man/man1/alacritty.1.gz"

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -x -o "$terminfo/share/terminfo" extra/alacritty.info
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    runHook postInstall
  '';

  dontPatchELF = true;

}
