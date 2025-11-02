{
  stdenv,
  lib,
  self,
  # To select only certain themes, pass `selected_themes` as a list of strings.
  selected_themes ? [ ],
}:
let
  version = "1.0";
  srcs = map (name: "${self}/resources/plymouth/${name}") selected_themes;
in
stdenv.mkDerivation {
  pname = "local-plymouth-themes";
  inherit version srcs;

  installPhase = ''
    mkdir -p $out/share/plymouth/themes
    for theme in ${toString selected_themes}; do
      cp -r $theme $out/share/plymouth/themes/$theme
    done
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
  '';

  meta = with lib; {
    description = "Plymouth boot themes from local flake";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}