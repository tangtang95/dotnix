{
  pkgs,
  lib,
  config,
  ...
}: let
  modifier = "Mod4";
in {
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = {
      modifier = modifier;
      terminal = config.defaultTerminal;
      fonts = {
        names = [config.fontMonoNerd];
        style = "Bold Semi-Condensed";
        size = 10.0;
      };
      # NOTE: use xwayland-satellite on display :1
      menu = "DISPLAY=:1 rofi -show drun -show-icons";
      bars = [
        {
          mode = "dock";
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];
      window = {
        titlebar = false;
      };
      startup = [
        {command = "xwayland-satellite";} # use xwayland-satellite instead of xwayland for correct scaling
        {command = "mako";}
        # {
        #   # idle mechanism TODO: fix this goes idle when using controller
        #   command = ''
        #     exec swayidle -w \
        #               timeout 300 'swaylock -f -c 000000' \
        #               timeout 600 'swaymsg "output * dpms off"' \
        #                    resume 'swaymsg "output * dpms on"' \
        #               before-sleep 'swaylock -f -c 000000'
        #   '';
        # }
        # TODO:
        # exec /usr/lib/xdg-desktop-portal --replace
      ];
      defaultWorkspace = "workspace number 1";
      output = {
        HDMI-A-2 = {
          scale = "2";
          bg = "${../wallpapers/yoichi-isagi-blue-3840x2160.jpg} fill";
        };
      };
      keybindings = let
        notify-send = "${pkgs.libnotify}/bin/notify-send";
        grim = "${pkgs.grim}/bin/grim";
      in
        lib.mkOptionDefault {
          "${modifier}+b" = "exec firefox";
          "${modifier}+q" = "kill";
          "${modifier}+Shift+1" = "move container to workspace number 1; workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2; workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3; workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4; workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5; workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6; workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7; workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8; workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9; workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10; workspace number 10";
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${config.audioRaiseCommand}";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${config.audioLowerCommand}";
          "XF86AudioMute" = "exec --no-startup-id ${config.audioToggleCommand}";
          "Print" = "exec ${grim} -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') - | wl-copy && ${notify-send} \"Screen copied to clipboard\" -t 5000";
        };
    };
  };
}
