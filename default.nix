{ nixpkgsSrc ? <nixpkgs>
}:

with builtins;
let
  haskellNix = import (builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/a9efc0ae3a607eaebc6e841ca3960134e9034077.tar.gz") {};
  pkgs = import nixpkgsSrc haskellNix.nixpkgsArgs;
  project = pkgs.haskell-nix.cabalProject {
    name = "composite-base";
    src = ./.;
    cabalProject = readFile ./cabal.project;
    compiler-nix-name = "ghc925";
    index-state = "2023-12-01T00:00:00Z";
  };
  shell = project.shellFor {
    tools = {
      cabal = "3.10.1.0";
    };
    exactDeps = true;
  };
in { inherit project shell; }
