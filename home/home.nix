{
  pkgs,
  lib,
  config,
  username,
  installGui ? true,
  ...
}: let
  guiPkgs =
    if installGui
    then
      with pkgs; [
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
      ]
    else [];
in {
  imports =
    [
      ./options.nix
      ./stylix.nix
      ./programs/git.nix
    ]
    ++ (
      if installGui
      then [
        ./programs/sway.nix
        ./programs/waybar.nix
        ./programs/gnome.nix
      ]
      else []
    );

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
  home.keyboard = {
    layout = "us";
  };
  home.packages =
    [
      # new coreutils
      pkgs.ripgrep
      pkgs.ripgrep-all
      pkgs.fd
      pkgs.bottom
      pkgs.du-dust
      pkgs.sd
      pkgs.procs
      pkgs.tailspin

      # web tools
      pkgs.wget
      pkgs.httpie
      pkgs.termscp
      pkgs.dogdns
      pkgs.bandwhich

      # file processors
      pkgs.jq
      pkgs.jqp
      pkgs.yq
      pkgs.zip
      pkgs.unzip
      pkgs.hexyl

      # text editors
      pkgs.vim
      pkgs.delta

      # languages
      (pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-analyzer" "rust-src" "llvm-tools"];
        targets = ["i686-pc-windows-msvc"];
      })
      pkgs.zigpkgs."0.14.1"
      (pkgs.python3.withPackages (ps: with ps; [pip]))
      (pkgs.lua51Packages.lua.withPackages (ps: with ps; [jsregexp luarocks]))
      pkgs.gnumake
      pkgs.nodejs
      pkgs.go
      pkgs.typst
      pkgs.gcc

      # cargo packages
      pkgs.cargo-llvm-cov
      pkgs.cargo-cross
      pkgs.unstable.cargo-xwin

      # lsp only for nixos
      pkgs.nixd
      pkgs.gopls
      pkgs.zls
      pkgs.lua-language-server
      pkgs.marksman

      # formatters only for nixos
      pkgs.alejandra

      # language tools
      pkgs.tree-sitter

      # dap (debugger tool)
      pkgs.vscode-extensions.vadimcn.vscode-lldb
      pkgs.lldb

      # benchmarking tools
      pkgs.samply
      pkgs.hyperfine

      # others
      pkgs.presenterm
      pkgs.python313Packages.weasyprint # for presenterm export pdf
      pkgs.rclone
      pkgs.just
      pkgs.fastfetch # fetch OS info
      pkgs.onefetch # fetch git info
      pkgs.tokei
      pkgs.onefetch
      pkgs.tealdeer
      pkgs.xclip
      pkgs.xdg-utils
      pkgs.watchexec
      pkgs.nerd-fonts.jetbrains-mono
    ]
    ++ guiPkgs;
  home.sessionVariables = {
    EDITOR = "nvim";
    NVIM_USE_NIXOS_MODULE = "true";
  };

  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
    sway.enable = true;
  };

  # zellij static config file (because limitation in nix to kdl converter)
  xdg.configFile."zellij/config.kdl".source = ../config/zellij.kdl;

  # enable user fonts
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [config.fontMonoNerd];
      sansSerif = [config.fontMonoNerd];
      monospace = [config.fontMonoNerd];
      emoji = [config.fontMonoNerd];
    };
  };

  programs =
    {
      home-manager.enable = true;
      fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
        '';
        shellAliases = {
          pbcopy = "xclip -selection clipboard";
          pbpaste = "xclip -selection clipboard -o";
        };
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      eza = {
        enable = true;
        icons = "auto";
      };
      bat = {
        enable = true;
      };
      zoxide = {
        enable = true;
      };
      starship = {
        enable = true;
        enableFishIntegration = true;
      };
      fzf = {
        enable = true;
        enableFishIntegration = true;
      };
      zellij = {
        enable = true;
        enableFishIntegration = true;
      };
      lazygit.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
      };
    }
    // (
      if installGui
      then {
        ghostty = {
          enable = true;
          package = pkgs.unstable.ghostty;
          settings = {
            theme = "Catppuccin Mocha";
            font-family = config.fontMonoNerd;
            gtk-titlebar = false;
            confirm-close-surface = false;
            cursor-style = "block";
            shell-integration-features = "no-cursor";
          };
        };
        alacritty = {
          enable = true;
          settings = {
            window.dimensions = {
              columns = 100;
              lines = 25;
            };
            font.normal.family = lib.mkForce "JetBrainsMono Nerd Font Mono";
            font.size = 12;
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
          package = pkgs.unstable.rofi;
          font = lib.mkForce "${config.fontMonoNerd} 14";
        };
      }
      else {}
    );

}
