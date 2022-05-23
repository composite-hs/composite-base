let
  packages = {
    base          = import ./package.nix;
  };
in
  packages // {
    overrides = self: super: {
      composite-base          = self.callPackage packages.base {};
    };
  }
