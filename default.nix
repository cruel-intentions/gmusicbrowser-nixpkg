{
  pkgs ? import <nixpkgs> {},
  stdenv ? pkgs.stdenv,
  lib ? pkgs.lib,
  perlPackages ? pkgs.perlPackages,
  wrapGAppsHook ? pkgs.wrapGAppsHook,
  gmb ? null,
  ...
}:
let
  gmbData = 
    let
      flakeLock = builtins.fromJSON (builtins.readFile ./flake.lock);
      gmbLock = flakeLock.nodes.gmb.locked;
      outPath = builtins.fetchGit {
        url = "git@github.com:${gmbLock.owner}/${gmbLock.repo}.git";
        rev = gmbLock.rev;
      };
      info = gmbLock // { inherit outPath; };
    in if builtins.isAttrs gmb  then gmb else info;
  perlDeps = with perlPackages; [
    perl
    Cairo
    CairoGObject
    Pango
    Gtk3
    Glib
    GlibObjectIntrospection
    LocaleGettext
    NetDBus
    XMLTwig
    XMLParser
    HTMLParser
  ];
in stdenv.mkDerivation {
  pname = "gmusicbrowser";
  src = gmbData.outPath;
  version = builtins.substring 0 7 gmbData.rev;
  meta.branch = "master";
  meta.homepage = "https://gmusicbrowser.org/";
  meta.description = "jukebox for large collections of music";
  meta.license = lib.licenses.gpl3;
  meta.platforms = lib.platforms.all;
  nativeBuildInputs = [ wrapGAppsHook ];
  buildInputs = with pkgs; [
    pandoc
    gettext
    discount
    gtk3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ] ++ perlDeps;
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PERL5LIB : ${perlPackages.makePerlPath perlDeps}
    )
  '';
  preBuild = ''
    substituteInPlace Makefile --replace usr $out
  '';
}
