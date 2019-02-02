self: super: 
with super;
{
  zshThemes = {
    spaceship = stdenv.mkDerivation rec {
        pname = "spaceship-prompt";
        version = "3.10.0";
        name = "zsh-${pname}-${version}";

        src = fetchFromGitHub {
          owner = "denysdovhan";
          repo = pname;
          rev= "0e84e3816311f33d16fb617de0fe8d2653b10441";
          sha256 = "03rjc3y24sz97x1fi6g66ky0pgw2q6z5r33vaprvnd2axay8pbdz";
        };

        buildInputs = [ zsh ];

        installPhase = ''
          chmod +x spaceship.zsh
          patchShebangs .
          mkdir -p $out $out/share/zsh/site-functions
          cp -av spaceship.zsh lib scripts sections $out
          ln -sf $out/spaceship.zsh $out/share/zsh/site-functions/prompt_spaceship_setup
        '';
    };
  };

  zshPlugins = {
    nix-shell = stdenv.mkDerivation rec {
        pname = "zsh-nix-shell";
        version = "unstable";
        name = "${pname}-${version}";

        src = fetchFromGitHub {
          owner = "chisui";
          repo = pname;
          rev= "dceed031a54e4420e33f22a6b8e642f45cc829e2";
          sha256 = "10g8m632s4ibbgs8ify8n4h9r4x48l95gvb57lhw4khxs6m8j30q";
        };

        buildInputs = [ zsh ];

        installPhase = ''
          patchShebangs .
          mkdir -p $out
          cp -av nix-shell.plugin.zsh scripts $out
        '';
    };
  };
}
