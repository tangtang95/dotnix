{
  pkgs,
  lib,
  config,
  username,
  installGui ? true,
  ...
}: let
  # catppuccin mocha colors
  themeColors = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#7f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };
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
      pkgs.bat
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

  wayland.windowManager.sway = lib.mkIf installGui {
    enable = true;
    package = null;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      # TODO:
      # set $uifont "Ubuntu 14"
      # fonts = {};
      # set $highlight #3daee9
      # set $prompt #18b218
      # NOTE: use xwayland-satellite on display :1
      menu = "DISPLAY=:1 rofi -show drun -show-icons";
      startup = [
        {command = "xwayland-satellite";} # use xwayland-satellite instead of xwayland for correct scaling
        {command = "mako";}
        {
          # idle mechanism
          command = ''
            exec swayidle -w \
                      timeout 300 'swaylock -f -c 000000' \
                      timeout 600 'swaymsg "output * dpms off"' \
                           resume 'swaymsg "output * dpms on"' \
                      before-sleep 'swaylock -f -c 000000'
          '';
        }
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
        modifier = config.wayland.windowManager.sway.config.modifier;
        wpctl = "${pkgs.wireplumber}/bin/wpctl";
        notify-send = "${pkgs.libnotify}/bin/notify-send";
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
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1 && ${notify-send} \"🔊 Volume Up\" -t 1000";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%- && ${notify-send} \"🔊 Volume Down\" -t 1000";
          "XF86AudioMute" = "exec --no-startup-id ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle && ${notify-send} \"🔇 Mute Toggled\" -t 1000";
        };
    };
  };

  # zellij static config file (because limitation in nix to kdl converter)
  xdg.configFile."zellij/config.kdl".source = ../config/zellij.kdl;

  # enable user fonts
  fonts.fontconfig.enable = true;

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
      git = import ../programs/git.nix;
      lazygit = {
        enable = true;
        settings = {
          gui = {
            theme = {
              activeBorderColor = [themeColors.blue "bold"];
              inactiveBorderColor = [themeColors.subtext0];
              optionsTextColor = [themeColors.blue];
              selectedLineBgColor = [themeColors.surface0];
              cherryPickedCommitBgColor = [themeColors.surface1];
              cherryPickedCommitFgColor = [themeColors.blue];
              unstagedChangesColor = [themeColors.red];
              defaultFgColor = [themeColors.text];
              searchingActiveBorderColor = [themeColors.yellow];
            };
            authorColors = {
              "Tangtang Zhou" = themeColors.mauve;
              "*" = themeColors.lavender;
            };
          };
        };
      };
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
            font-family = "JetBrainsMono Nerd Font Mono";
            gtk-titlebar = false;
            confirm-close-surface = false;
            cursor-style = "block";
            shell-integration-features = "no-cursor";
          };
        };
        alacritty = (import ../programs/alacritty.nix) {
          inherit pkgs;
          inherit themeColors;
        };
        thunderbird = {
          enable = true;
          profiles = {
            default = {
              isDefault = true;
            };
          };
        };
        gnome-shell = {
          enable = true;
          extensions = with pkgs.gnomeExtensions; [
            {package = clipboard-indicator;}
            {package = simple-workspaces-bar;}
            {package = forge;}
            {package = appindicator;}
            {package = disable-workspace-animation;}
          ];
        };
      }
      else {}
    );

  # only gnome settings
  dconf.settings = lib.mkIf installGui {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "Alacritty.desktop"
        "firefox.desktop"
        "thunderbird.desktop"
        "discord.desktop"
        "obsidian.desktop"
        "spotify.desktop"
        "bitwarden.desktop"
      ];
    };
    # appeareance
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      scaling-factor = lib.gvariant.mkUint32 2; # for log-in screen
    };
    # power
    "org/gnome/desktop/session" = {
      idle-delay = lib.gvariant.mkUint32 600;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-timeout = lib.gvariant.mkInt32 1800;
    };
    # shortcuts
    "org/gnome/settings-daemon/plugins/media-keys" = {
      screensaver = []; # remove lock screen shortcut which default nixos gnome is <Super>l
    };
    "org/gnome/shell/keybindings" = {
      # remove all switch to app since default is <Super>1, ...
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
    };
    "org/gnome/desktop/wm/keybindings" = {
      minimize = [];
      maximize = [];
      unmaximize = [];
      close = ["<Alt>F4" "<Super>q"];
      move-to-workspace-1 = ["<Shift><Super>1"];
      move-to-workspace-2 = ["<Shift><Super>2"];
      move-to-workspace-3 = ["<Shift><Super>3"];
      move-to-workspace-4 = ["<Shift><Super>4"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [];
      toggle-tiled-right = [];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      www = ["<Super>b"];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "open-terminal";
      command = "alacritty";
      binding = "<Super>Return";
    };
    # extensions
    "org/gnome/shell/extensions/clipboard-indicator" = {
      toggle-menu = ["<Super>p"];
    };
    "org/gnome/shell/extensions/forge" = {
      move-pointer-focus-enabled = false;
    };
    "org/gnome/shell/extensions/forge/keybindings" = {
      window-swap-last-active = []; # Remove <Super>Return shortcut
    };
  };
}
