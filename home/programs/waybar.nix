{
  terminal,
  audioToggleCommand,
  audioRaiseCommand,
  audioLowerCommand,
}: {
  enable = true;
  settings = [
    {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 1;
      margin = "0";

      modules-left = ["sway/workspaces" "sway/mode" "custom/weather"];
      modules-center = [];
      modules-right = ["clock" "wireplumber" "backlight" "bluetooth" "network" "cpu" "memory" "battery" "tray"];

      "sway/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{name}";
      };

      "sway/mode" = {
        format = "<span style=\"italic\">{}</span>";
      };

      "custom/weather" = {
        exec = "curl 'https://wttr.in/?format=1'";
        interval = 3600;
        format = "{}";
        tooltip = true;
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "󰈈";
          deactivated = "󰈉";
        };
        tooltip = true;
      };

      clock = {
        format = "󰥔 {:%H:%M}";
        format-alt = "󰃮 {:%d/%m/%Y}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          weeks-pos = "right";
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            # TODO: use stylix base16 colors
            months = "<span color='#d3c6aa'><b>{}</b></span>";
            days = "<span color='#e67e80'>{}</span>";
            weeks = "<span color='#a7c080'><b>W{}</b></span>";
            weekdays = "<span color='#7fbbb3'><b>{}</b></span>";
            today = "<span color='#dbbc7f'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      cpu = {
        format = "󰘚 {usage}%";
        tooltip = true;
        interval = 1;
        on-click = "${terminal} -e btm";
      };

      memory = {
        format = "󰍛 {}%";
        interval = 1;
        on-click = "${terminal} -e btm";
      };

      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󰚥 {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
      };

      bluetooth = {
        format = " {status}";
        format-disabled = "";
        format-connected = " {num_connections} connected";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        on-click = "blueman-manager";
      };

      network = {
        format-wifi = "󰖩 {essid} ({signalStrength}%)";
        format-ethernet = "󰈀 {ifname}";
        format-linked = "󰈀 {ifname} (No IP)";
        format-disconnected = "󰖪 Disconnected";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        tooltip-format = "{ifname}: {ipaddr}";
        on-click = "${terminal} -e nmtui";
      };

      wireplumber = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        format-icons = {
          headphone = "󰋋";
          hands-free = "󰥰";
          headset = "󰋎";
          phone = "󰏲";
          portable = "󰄝";
          car = "󰄋";
          default = ["󰕿" "󰖀" "󰕾"];
        };
        on-click = "pavucontrol";
        on-click-right = "${audioToggleCommand}";
        on-scroll-up = "${audioRaiseCommand}";
        on-scroll-down = "${audioLowerCommand}";
      };

      backlight = {
        format = "{icon} {percent}%";
        format-icons = ["󰃞" "󰃟" "󰃠"];
        on-scroll-up = "brightnessctl set +5%";
        on-scroll-down = "brightnessctl set 5%-";
      };

      disk = {
        interval = 30;
        format = "󰋊 {percentage_used}%";
        path = "/";
        on-click = "${terminal} -e btm";
      };

      tray = {
        icon-size = 18;
        spacing = 5;
      };
    }
  ];
  style = ''
    /* Colors based on base16 scheme */
    @define-color background @base00;
    @define-color background-light @base01;
    @define-color foreground @base05;
    @define-color black @base0F;
    @define-color red @base08;
    @define-color green @base0B;
    @define-color yellow @base0A;
    @define-color blue @base0D;
    @define-color magenta @base0E;
    @define-color cyan @base0C;
    @define-color white @base06;
    @define-color orange @base09;

    /* Module-specific colors */
    @define-color workspaces-color @foreground;
    @define-color workspaces-focused-bg @green;
    @define-color workspaces-focused-fg @cyan;
    @define-color workspaces-urgent-bg @red;
    @define-color workspaces-urgent-fg @black;

    /* Text and border colors for modules */
    @define-color mode-color @orange;
    @define-color mpd-color @magenta;
    @define-color weather-color @magenta;
    @define-color playerctl-color @magenta;
    @define-color clock-color @blue;
    @define-color cpu-color @green;
    @define-color memory-color @magenta;
    @define-color temperature-color @yellow;
    @define-color temperature-critical-color @red;
    @define-color battery-color @cyan;
    @define-color battery-charging-color @green;
    @define-color battery-warning-color @yellow;
    @define-color battery-critical-color @red;
    @define-color network-color @blue;
    @define-color network-disconnected-color @red;
    @define-color network-color @blue;
    @define-color bluetooth-color @magenta;
    @define-color wireplumber-color @orange;
    @define-color wireplumber-muted-color @red;
    @define-color backlight-color @yellow;
    @define-color disk-color @cyan;
    @define-color uptime-color @green;
    @define-color updates-color @orange;
    @define-color quote-color @green;
    @define-color idle-inhibitor-color @foreground;
    @define-color idle-inhibitor-active-color @red;

    * {
        /* Base styling for all modules */
        border: none;
        border-radius: 0;
        font-family: "Iosevka Nerd Font";
        font-size: 14px;
        min-height: 0;
    }

    window#waybar {
        background-color: @background;
        color: @foreground;
    }

    /* Common module styling with border-bottom */
    #mode, #mpd, #custom-weather, #custom-playerctl, #clock, #cpu,
    #memory, #temperature, #battery, #network, #bluetooth, #wireplumber,
    #backlight, #disk, #custom-uptime, #custom-updates, #custom-quote,
    #idle_inhibitor, #tray {
        padding: 0 10px;
        margin: 0 2px;
        border-bottom: 2px solid transparent;
        background-color: transparent;
    }

    /* Workspaces styling */
    #workspaces button {
        padding: 0 10px;
        background-color: transparent;
        color: @workspaces-color;
        margin: 0;
    }

    #workspaces button:hover {
        background: @background-light;
        box-shadow: inherit;
    }

    #workspaces button.focused {
        box-shadow: inset 0 -2px @workspaces-focused-fg;
        color: @workspaces-focused-fg;
        font-weight: 900;
    }

    #workspaces button.urgent {
        background-color: @workspaces-urgent-bg;
        color: @workspaces-urgent-fg;
    }

    /* Module-specific styling */
    #mode {
        color: @mode-color;
        border-bottom-color: @mode-color;
    }

    #mpd {
        color: @mpd-color;
        border-bottom-color: @mpd-color;
    }

    #mpd.disconnected,
    #mpd.stopped {
        color: @foreground;
        border-bottom-color: transparent;
    }

    #custom-weather {
        color: @weather-color;
        border-bottom-color: @weather-color;
    }

    #clock {
        color: @clock-color;
        border-bottom-color: @clock-color;
    }

    #cpu {
        color: @cpu-color;
        border-bottom-color: @cpu-color;
    }

    #memory {
        color: @memory-color;
        border-bottom-color: @memory-color;
    }

    #temperature {
        color: @temperature-color;
        border-bottom-color: @temperature-color;
    }

    #temperature.critical {
        color: @temperature-critical-color;
        border-bottom-color: @temperature-critical-color;
    }

    #battery {
        color: @battery-color;
        border-bottom-color: @battery-color;
    }

    #battery.charging, #battery.plugged {
        color: @battery-charging-color;
        border-bottom-color: @battery-charging-color;
    }

    #battery.warning:not(.charging) {
        color: @battery-warning-color;
        border-bottom-color: @battery-warning-color;
    }

    #battery.critical:not(.charging) {
        color: @battery-critical-color;
        border-bottom-color: @battery-critical-color;
    }

    #bluetooth {
        color: @bluetooth-color;
        border-bottom-color: @bluetooth-color;
    }

    #network {
        color: @network-color;
        border-bottom-color: @network-color;
    }

    #network.disconnected {
        color: @network-disconnected-color;
        border-bottom-color: @network-disconnected-color;
    }

    #wireplumber {
        color: @wireplumber-color;
        border-bottom-color: @wireplumber-color;
    }

    #wireplumber.muted {
        color: @wireplumber-muted-color;
        border-bottom-color: @wireplumber-muted-color;
    }

    #backlight {
        color: @backlight-color;
        border-bottom-color: @backlight-color;
    }

    #disk {
        color: @disk-color;
        border-bottom-color: @disk-color;
    }

    #custom-uptime {
        color: @uptime-color;
        border-bottom-color: @uptime-color;
    }

    #custom-updates {
        color: @updates-color;
        border-bottom-color: @updates-color;
    }

    #custom-quote {
        color: @quote-color;
        border-bottom-color: @quote-color;
    }

    #idle_inhibitor {
        color: @idle-inhibitor-color;
        border-bottom-color: transparent;
    }

    #idle_inhibitor.activated {
        color: @idle-inhibitor-active-color;
        border-bottom-color: @idle-inhibitor-active-color;
    }

    #tray {
        background-color: transparent;
        padding: 0 10px;
        margin: 0 2px;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: @red;
        border-bottom-color: @red;
    }

  '';
}
