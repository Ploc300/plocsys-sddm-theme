{ lib, stdenvNoCC, ... }:
stdenvNoCC.mkDerivation {
  pname = "plocsys-sddm-theme";
  version = "0.1.0";

  src = ./src;
  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/share/sddm/themes/plocsys-sddm-theme"
    cp -r --no-preserve=mode,ownership "$src"/. \
      "$out/share/sddm/themes/plocsys-sddm-theme"
  '';

  meta = {
    description = "Plocsys custom SDDM theme";
    license = lib.license.mit;
    platforms = lib.platforms.linux;
  };
}
