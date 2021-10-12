{ pkgs, stdenv, lib, perlPackages, sources ? import ./nix/sources.nix }:
let
  gm = sources.gmusicbrowser;
in stdenv.mkDerivation {
  pname = "gmusicbrowser";
  src = gm.outPath;
  version = gm.version;
  meta.branch = gm.branch;
  meta.homepage = gm.homepage;
  meta.description = gm.description;
  meta.license = lib.licenses.gpl3;
  meta.platforms = lib.platforms.all;
  propagatedBuildInputs = with perlPackages; [
    Gtk2
    Glib
    LocaleGettext
    NetDBus
    perl
    pkgs.gettext
  ];

  buildPhase = "

  ";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/src
    cp -r $src/* $out/src/
    ln -s $out/src/gmusicbrowser.pl $out/bin/gmusicbrowser
  '';
}
