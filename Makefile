
.PHONY: build update-build clean reallyclean sdist

build: update-build
	cabal v2-test --ghc-options="-Wall -Werror"

update-build:
	nix-shell update-build-shell.nix --run ./update-build.sh

clean:
	cabal v2-clean

reallyclean:
	rm -rf .dist-newstyle _sdists

sdist: reallyclean build
	cabal v2-sdist
