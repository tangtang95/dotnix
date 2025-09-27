{installGui ? true, ...}: {
  stylix.targets =
    {
      neovim.enable = false;
    }
    // (
      if installGui
      then {
        waybar.addCss = false;
      }
      else {}
    );
}
