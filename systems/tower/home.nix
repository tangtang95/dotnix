{
  pkgs,
  lib,
  username,
  rootPath,
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
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
  home.keyboard = {
    layout = "us";
  };
  home.packages = [
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
      extensions = [ "rust-analyzer" "rust-src" "llvm-tools" ];
      targets = [ "i686-pc-windows-msvc" ];
    })
    # pkgs.zigpkgs.master-2025-03-06
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

    # language tools
    pkgs.tree-sitter

    # formatters
    pkgs.alejandra

    # dap (debugger tool)
    pkgs.vscode-extensions.vadimcn.vscode-lldb
    pkgs.lldb

    # benchmarking tools
    pkgs.samply
    pkgs.hyperfine

    # others
    pkgs.fzf
    pkgs.just
    pkgs.fastfetch
    pkgs.tokei
    pkgs.onefetch
    pkgs.tealdeer
    pkgs.xclip
    pkgs.xdg-utils
    pkgs.watchexec
    pkgs.nerd-fonts.jetbrains-mono

    # gui
    pkgs.gimp
    pkgs.spotify
    pkgs.qbittorrent
    pkgs.discord
    pkgs.onlyoffice-bin
    pkgs.vlc
    pkgs.whatsapp-for-linux
    pkgs.bitwarden-desktop
    pkgs.via # for keychron keyboard
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    LD_LIBRARY_PATH = "";
  };

  # zellij static config file (because limitation in nix to kdl converter)
  xdg.configFile."zellij/config.kdl".source = ../../config/zellij.kdl;

  # enable user fonts
  fonts.fontconfig.enable = true;

  programs = {
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
    zellij = {
      enable = true;
      enableFishIntegration = true;
    };
    git = import ../../programs/git.nix;
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
    gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        {package = clipboard-indicator;}
        {package = simple-workspaces-bar;}
      ];
    };
  };

  # gui programs
  programs = {
    ghostty = {
      enable = true;
      settings = {
        theme = "catppuccin-mocha";
      };
    };
    # thunderbird = {
    #   enable = true;
    #   package = pkgs.thunderbird;
    #   profiles = {
    #     default = {
    #       isDefault = true;
    #     };
    #   };
    # };
  };

  # only gnome settings (for pop-os)
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:swapescape"];
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-1 = ["<Shift><Super>1"];
      move-to-workspace-2 = ["<Shift><Super>2"];
      move-to-workspace-3 = ["<Shift><Super>3"];
      move-to-workspace-4 = ["<Shift><Super>4"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
    };
    "org/gnome/desktop/applications/terminal" = {
      exec = "ghostty";
      exec-arg = "";
    };
    "org/gnome/shell/extensions/clipboard-indicator" = {
      toggle-menu = ["<Super>p"];
    };
  };
}
