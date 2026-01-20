{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pyprojroot = pkgs.python3.pkgs.buildPythonPackage rec {
          pname = "pyprojroot";
          version = "0.3.0";
          format = "pyproject";
          src = pkgs.fetchPypi {
            inherit pname version;
            sha256 = "sha256-EJcFu3kJaHBJWO/PxczOhdjj2voFSJfMgTcfy79WyxA=";
          };
          propagatedBuildInputs = [
            pkgs.python3.pkgs.setuptools
            pkgs.python3.pkgs.typing-extensions
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.bashInteractive
            (pkgs.python3.withPackages (ps: [
              ps.ipython
              ps.jupyter
              ps.numpy
              ps.matplotlib
              ps.scipy
              ps.scikit-learn
              pyprojroot
            ]))
            (pkgs.rWrapper.override {
              packages = with pkgs.rPackages; [
                glmnet
                lars
                here
                languageserver
              ];
            })
          ];
        };
      }
    );
}
