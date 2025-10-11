{...}: {
  stylix.targets = {
    neovim.enable = false;
    waybar.addCss = false;
    qt.enable = false;
    firefox = {
      enable = true;
      colorTheme.enable = true;
      firefoxGnomeTheme.enable = true;
      profileNames = ["tangtang"];
    };
  };
}
