{
  pkgs,
  lib,
  nixGLWrap ? null,
}: {
  enable = true;
  package =
    if nixGLWrap == null
    then pkgs.alacritty
    else nixGLWrap pkgs.alacritty;
  settings = {
    window.dimensions = {
      columns = 100;
      lines = 25;
    };
    font.normal.family = lib.mkForce "JetBrainsMono Nerd Font Mono";
    font.size = 12;
  };
}
