{
  pkgs,
  lib,
  config,
  ...
}: let
  modifier = "Mod4";

  # NOTE: use xwayland-satellite on display :1
  x11display = ":1";
in {
  home.sessionVariables = {
    DISPLAY = x11display;
  };
  systemd.user = {
    sessionVariables = {
      DISPLAY = x11display;
    };
    services = let
      guiTarget = "graphical-session.target";
    in {
      # x11 apps in wayland: use xwayland-satellite instead of xwayland for correct scaling
      xwayland-satellite = {
        Unit = {
          Description = "XWayland outside your Wayland";
          BindsTo = guiTarget;
          PartOf = guiTarget;
          After = guiTarget;
          Requisite = guiTarget;
        };
        Service = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = lib.concatStringsSep " " [
            # TODO: remove unstable when xwayland-satellite goes to 0.8 (0.7 crashes at some point with steam)
            "${pkgs.unstable.xwayland-satellite}/bin/xwayland-satellite"
            x11display
          ];
          Restart = "on-failure";
        };
        Install.WantedBy = [guiTarget];
      };
      # idle mechanism (inhibit idle when playing audio; should work also for games)
      wayland-pipewire-idle-inhibit = {
        Unit = {
          Description = "Wayland PipeWire Idle Inhibit service";
        };
        Service = {
          ExecStart = lib.concatStringsSep " " [
            "${pkgs.wayland-pipewire-idle-inhibit}/bin/wayland-pipewire-idle-inhibit"
            "-v INFO"
          ];
          Restart = "on-failure";
        };
        Install.WantedBy = [guiTarget];
      };
    };
  };
  programs.swaylock = {
    enable = true;
    settings = {
      image = ../wallpapers/yoichi-isagi-blue-3840x2160.jpg;
    };
  };
  wayland.windowManager.sway = with config.default; {
    enable = true;
    package = null;
    swaynag = {
      enable = true;
      settings = {
        "<config>" = {
          font = fontMonoNerd;
        };
      };
    };
    config = {
      modifier = modifier;
      terminal = terminal;
      fonts = {
        names = [fontMonoNerd];
        style = "Bold Semi-Condensed";
        size = 10.0;
      };
      menu = "DISPLAY=${x11display} rofi -show drun -show-icons";
      bars = [
        {
          mode = "dock";
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];
      gaps = {
        inner = 5;
        outer = 5;
      };
      window = {
        titlebar = false;
        commands = [
          {
            criteria = {
              app_id = "discord";
            };
            command = "move container to workspace 8";
          }
          {
            criteria = {
              app_id = "spotify";
            };
            command = "move container to workspace 10";
          }
        ];
      };
      startup = [
        {command = "mako";}
        {command = "${pkgs.autotiling-rs}/bin/autotiling-rs";}
        {command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";} # polkit auth agent
        {command = "systemctl --user restart xdg-desktop-portal-gtk.service xdg-desktop-portal-wlr.service";} # temporary fix for bug in quick logout and login where portal gtk and wlr does not start

        {
          command = ''
            exec swayidle -w \
                   timeout 600 'swaylock -f -c 000000' \
                   timeout 900 'swaymsg "output * dpms off"' \
                   resume 'swaymsg "output * dpms on"' \
                   timeout 3600 'systemctl suspend' \
                   before-sleep 'swaylock -f -c 000000'
          '';
        }
      ];
      defaultWorkspace = "workspace number 1";
      output = {
        HDMI-A-2 = {
          scale = "2";
          bg = "${../wallpapers/tanjiro-kamado-red.png} fill";
        };
      };
      keybindings = let
        notify-send = "${pkgs.libnotify}/bin/notify-send";
        grim = "${pkgs.grim}/bin/grim";
        cliphist-rofi-img = "${pkgs.cliphist}/bin/cliphist-rofi-img";
      in
        lib.mkOptionDefault {
          "${modifier}+b" = "exec ${browser}";
          "${modifier}+q" = "kill";
          "${modifier}+p" = "exec --no-startup-id rofi -show clipboard:${cliphist-rofi-img} -show clipboard";
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
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${audioRaiseCommand}";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${audioLowerCommand}";
          "XF86AudioMute" = "exec --no-startup-id ${audioToggleCommand}";
          "Print" = "exec ${grim} -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') - | wl-copy && ${notify-send} \"Screen copied to clipboard\" -t 5000";
        };
    };
  };
}
