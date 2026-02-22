{
  pkgs,
  lib,
  config,
  ...
}: let
  term = config.default.terminal;
  ghosttyNoDBus =
    pkgs.ghostty.overrideAttrs
    (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          # Remove DBusActivatable line from desktop file
          substituteInPlace $out/share/applications/*.desktop \
          --replace-fail "DBusActivatable=true" ""
        '';
    });
in {
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
      fileManagerApp = "org.kde.dolphin.desktop";
      imageViewerApp = "org.gnome.Loupe.desktop";
      emailApp = "userapp-Thunderbird-PB4G92.desktop";
      archiverApp = "org.gnome.FileRoller.desktop";
      textApp = "nvim.desktop";
    in {
      "inode/directory" = fileManagerApp;
      "inode/mount-point" = fileManagerApp;
      "application/x-zip" = archiverApp;
      "application/x-gzip" = archiverApp;
      "application/x-lzip" = archiverApp;
      "application/x-tar" = archiverApp;
      "application/x-compressed-tar" = archiverApp;
      "application/pdf" = "org.gnome.Papers.desktop";
      "x-scheme-handler/mailto" = emailApp;
      "message/rfc822" = emailApp;
      "x-scheme-handler/mid" = emailApp;
      "text/plain" = textApp;
      "text/x-log" = textApp;
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
  xdg.configFile."kdeglobals".text = ''
    [General]
    TerminalApplication=${term}
    TerminalExec=${term} -e
  '';

  home.packages = with pkgs; [
    gimp
    spotify
    qbittorrent
    discord
    wasistlos
    bitwarden-desktop
    obsidian
    yubioath-flutter # yubico
    localsend # file sharing
    ghidra # reverse engineering
    qdirstat # disk space analyzer
  ];

  # clipboard manager
  services.cliphist.enable = true;

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
      package = ghosttyNoDBus;
      settings = {
        confirm-close-surface = false;
      };
    };
  };

  services = {
    wlsunset = {
      enable = true;
      latitude = "45.46";
      longitude = "9.19";
      temperature = {
        day = 6500;
        night = 4000;
      };
    };
  };
}
