self: super:
with super; {
  wl-clipboard = wl-clipboard.overrideAttrs (old: rec {
    src = fetchFromGitHub {
      owner = "bugaevc";
      repo = "wl-clipboard";
      rev = "cef29eac68d00e2c5e3d35c4f23804de24e15642";
      sha256 = "0ayw14j7fq4y48mfgd57z2vsxqc4zgvpfc3ancs1yp3bvl6m6f9g";
    };
  });
}
