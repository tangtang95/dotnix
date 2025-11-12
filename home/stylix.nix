{pkgs, config, ...}: {
  stylix = {
    fonts = {
      sizes = {
        popups = 11;
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = config.default.fontMonoNerd;
      };
    };
    targets = {
      neovim.enable = false;
      waybar.addCss = false;
      firefox = {
        enable = true;
        colorTheme.enable = true;
        firefoxGnomeTheme.enable = true;
        profileNames = ["tangtang"];
      };
    };
  };
}
