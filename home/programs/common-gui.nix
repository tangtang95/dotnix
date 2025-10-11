{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    gimp
    spotify
    qbittorrent
    discord
    libreoffice
    vlc
    whatsapp-for-linux
    bitwarden-desktop
    obsidian
    yubioath-flutter # yubico
    localsend # file sharing
  ];

  programs = {
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
    alacritty = {
      enable = true;
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
    thunderbird = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
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
  };
}
