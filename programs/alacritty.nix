{
  pkgs,
  themeColors,
  nixGLWrap,
}: {
  enable = true;
  package = nixGLWrap pkgs.alacritty;
  settings = {
    window.dimensions = {
      columns = 100;
      lines = 25;
    };
    font.normal.family = "JetBrainsMono Nerd Font";
    font.size = 12;
    colors = {
      primary = {
        background = themeColors.base;
        foreground = themeColors.text;
        dim_foreground = themeColors.text;
        bright_foreground = themeColors.text;
      };
      cursor = {
        text = themeColors.base;
        cursor = themeColors.pink;
      };
      vi_mode_cursor = {
        text = themeColors.base;
        cursor = themeColors.lavender;
      };
      search.matches = {
        foreground = themeColors.base;
        background = themeColors.green;
      };
      search.focused_match = {
        foreground = themeColors.base;
        background = themeColors.subtext0;
      };
      footer_bar = {
        foreground = themeColors.base;
        background = themeColors.green;
      };
      hints.start = {
        foreground = themeColors.base;
        background = themeColors.yellow;
      };
      hints.end = {
        foreground = themeColors.base;
        background = themeColors.green;
      };
      selection = {
        text = themeColors.base;
        background = themeColors.rosewater;
      };
      normal = {
        black = themeColors.surface1;
        red = themeColors.red;
        green = themeColors.green;
        yellow = themeColors.yellow;
        blue = themeColors.blue;
        magenta = themeColors.pink;
        cyan = themeColors.teal;
        white = themeColors.subtext1;
      };
      bright = {
        black = themeColors.surface2;
        red = themeColors.red;
        green = themeColors.green;
        yellow = themeColors.yellow;
        blue = themeColors.blue;
        magenta = themeColors.pink;
        cyan = themeColors.teal;
        white = themeColors.subtext0;
      };
      dim = {
        black = themeColors.surface1;
        red = themeColors.red;
        green = themeColors.green;
        yellow = themeColors.yellow;
        blue = themeColors.blue;
        magenta = themeColors.pink;
        cyan = themeColors.teal;
        white = themeColors.subtext1;
      };
      indexed_colors = [
        {
          index = 16;
          color = themeColors.peach;
        }
        {
          index = 17;
          color = themeColors.rosewater;
        }
      ];
    };
  };
}
