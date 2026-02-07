{
  description = "Decode Orc Documentation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          mkdocs
          mkdocs-material
          mkdocs-awesome-nav
        ]);

      in
      {
        packages = {
          # Build the documentation site
          default = pkgs.stdenv.mkDerivation {
            pname = "decode-orc-docs";
            version = "0.1.0";
            src = ./.;

            nativeBuildInputs = [ pythonEnv ];

            buildPhase = ''
              mkdocs build
            '';

            installPhase = ''
              mkdir -p $out
              cp -r site/* $out/
            '';
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
          ];

          shellHook = ''
            echo "🚀 Decode Orc Documentation Development Environment"
            echo ""
            echo "Available commands:"
            echo "  mkdocs serve  - Start local dev server (http://127.0.0.1:8000)"
            echo "  mkdocs build  - Build static site to site/"
            echo "  nix build     - Build docs package"
            echo ""
          '';
        };
      }
    );
}
