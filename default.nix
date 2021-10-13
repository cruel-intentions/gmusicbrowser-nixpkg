{ pkgs, stdenv, lib, perlPackages, makeWrapper, sources ? import ./nix/sources.nix }:
let
  gm = sources.gmusicbrowser;
  perlDeps = with perlPackages; [
    perl
    Cairo
    Pango
    Gtk2
    Glib
    LocaleGettext
    NetDBus
    XMLTwig
    XMLParser
  ];
in stdenv.mkDerivation {
  pname = "gmusicbrowser";
  src = gm.outPath;
  version = gm.version;
  meta.branch = gm.branch;
  meta.homepage = gm.homepage;
  meta.description = gm.description;
  meta.license = lib.licenses.gpl3;
  meta.platforms = lib.platforms.all;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = with pkgs; [
    pandoc
    gettext
    discount
  ] ++ perlDeps;
  preBuild = ''
  substituteInPlace Makefile --replace usr $out
  '';
  postInstall = ''
    wrapProgram "$out/bin/gmusicbrowser" \
      --prefix PERL5LIB : ${perlPackages.makePerlPath perlDeps}
  '';
}
