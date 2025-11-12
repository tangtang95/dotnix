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
  dconf.settings = {
    # gtk apps appeareance
    "org/gnome/desktop/interface" = {
      color-scheme = lib.mkForce "prefer-dark";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      imageViewerApp = "org.gnome.Loupe.desktop";
      emailApp = "userapp-Thunderbird-PB4G92.desktop";
      archiverApp = "org.gnome.FileRoller.desktop";
    in {
      "application/x-zip" = archiverApp;
      "application/x-gzip" = archiverApp;
      "application/x-lzip" = archiverApp;
      "application/x-tar" = archiverApp;
      "application/pdf" = "org.gnome.Papers.desktop";
      "x-scheme-handler/mailto" = emailApp;
      "message/rfc822" = emailApp;
      "x-scheme-handler/mid" = emailApp;
      "image/jpeg" = imageViewerApp;
      "image/png" = imageViewerApp;
      "image/gif" = imageViewerApp;
      "image/webp" = imageViewerApp;
      "image/tiff" = imageViewerApp;
      "image/x-tga" = imageViewerApp;
      "image/vnd-ms.dds" = imageViewerApp;
      "image/x-dds" = imageViewerApp;
      "image/bmp" = imageViewerApp;
      "image/vnd.microsoft.icon" = imageViewerApp;
      "image/vnd.radiance" = imageViewerApp;
      "image/x-exr" = imageViewerApp;
      "image/x-portable-bitmap" = imageViewerApp;
      "image/x-portable-graymap" = imageViewerApp;
      "image/x-portable-pixmap" = imageViewerApp;
      "image/x-portable-anymap" = imageViewerApp;
      "image/x-qoi" = imageViewerApp;
      "image/qoi" = imageViewerApp;
      "image/svg+xml" = imageViewerApp;
      "image/svg+xml-compressed" = imageViewerApp;
      "image/avif" = imageViewerApp;
      "image/heic" = imageViewerApp;
      "image/jxl" = imageViewerApp;
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
    ghidra # reverse engineering
    qdirstat # disk space analyzer
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

    # other
    ghostty = {
      enable = true;
      package = pkgs.unstable.ghostty;
      settings = {
        confirm-close-surface = false;
      };
    };
  };
}
