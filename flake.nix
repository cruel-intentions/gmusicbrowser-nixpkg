{
  description = "jukebox for large collections of music";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.gmb.url = "github:squentin/gmusicbrowser";
  inputs.gmb.flake = false;

  outputs = { self, flake-utils, nixpkgs, gmb }:
  flake-utils.lib.eachDefaultSystem (system: {
    defaultPackage = nixpkgs.legacyPackages.${system}.callPackage ./default.nix { inherit gmb; };
  });
}
