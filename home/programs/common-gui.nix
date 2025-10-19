{
  pkgs,
  lib,
  config,
  ...
}: {
  gtk = {
    enable = true;
    # NOTE: adwaita seems to provide faster startup time for gnome apps
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  # thunar config
  home.file.".config/xfce4/helpers.rc".text = "TerminalEmulator=${config.default.terminal}";
  xfconf = {
    enable = true;
    settings = {
      thunar = {
        last-menubar-visible = false;
      };
    };
  };

  home.packages = with pkgs; [
    gimp
    spotify
    qbittorrent
    discord
    whatsapp-for-linux
    bitwarden-desktop
    obsidian
    yubioath-flutter # yubico
    localsend # file sharing
  ];

  programs = {
    # default apps
    # movie player
    mpv = {
      enable = true;
    };
    alacritty = {
      enable = true;
    };
    thunderbird = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
        };
      };
    };
    firefox = {
      enable = true;
      profiles = {
        tangtang = {
          isDefault = true;
          name = "tangtang";
          extensions = {
            force = true;
          };
        };
      };
    };

    # other
    ghostty = {
      enable = true;
      package = pkgs.unstable.ghostty;
      settings = {
        command = "${pkgs.zellij}/bin/zellij";
        confirm-close-surface = false;
      };
    };
    rofi = {
      enable = true;
      package = pkgs.unstable.rofi; #TODO: after 25.05 remove unstable for 2.0.0 that supports wayland when available in stable
      extraConfig = {
        display-drun = "";
      };
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        window = {
          border = mkLiteral "1px solid";
        };
        mainbox = {
          padding = mkLiteral "10px";
        };
      };
    };
  };
}
