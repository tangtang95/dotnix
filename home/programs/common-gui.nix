{
  pkgs,
  lib,
  config,
  ...
}: {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      imageViewerApp = "org.gnome.Loupe.desktop";
      emailApp = "userapp-Thunderbird-PB4G92.desktop";
    in {
      "x-scheme-handler/mailto" = emailApp;
      "message/rfc822" = emailApp;
      "x-scheme-handler/mid" = emailApp;
      "application/pdf" = "org.gnome.Papers.desktop";
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
        gtk-titlebar = false;
        confirm-close-surface = false;
        cursor-style = "block";
        shell-integration-features = "no-cursor";
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
