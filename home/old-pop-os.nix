{
  pkgs,
  lib,
  ...
}: let
  nixGLWrap = pkg:
    pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/*; do
       wrapped_bin=$out/bin/$(basename $bin)
       echo "exec ${lib.getExe' pkgs.nix-gl-host "nixglhost"} $bin \"\$@\"" > $wrapped_bin
      chmod +x $wrapped_bin
      done
    '';
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
  home.username = "tangtang";
  home.homeDirectory = "/home/tangtang";
  home.stateVersion = "24.11";
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
      extensions = ["rust-analyzer" "rust-src" "llvm-tools"];
      targets = ["i686-pc-windows-msvc"];
    })
    pkgs.zigpkgs.master-2025-03-06
    (pkgs.python3.withPackages (ps: with ps; [pip]))
    (pkgs.lua.withPackages (ps: with ps; [jsregexp]))
    pkgs.gnumake
    pkgs.nodejs
    pkgs.go
    pkgs.typst

    # cargo packages
    pkgs.cargo-llvm-cov
    pkgs.cargo-cross
    pkgs.unstable.cargo-xwin

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

    # guis
    pkgs.nix-gl-host
    (nixGLWrap pkgs.wineWowPackages.full)
    (nixGLWrap pkgs.firefox) # must have a browser installed with nix as default browser
    (nixGLWrap pkgs.gimp)
    (nixGLWrap pkgs.spotify)
    (nixGLWrap pkgs.qbittorrent)
    (nixGLWrap pkgs.discord)
    (nixGLWrap pkgs.onlyoffice-bin)
    (nixGLWrap pkgs.vlc)
    (nixGLWrap pkgs.evince) # document viewer
    (nixGLWrap pkgs.ghostty)
    (nixGLWrap pkgs.whatsapp-for-linux) # need to disable hardware acceleration
    (nixGLWrap pkgs.via) # for keychron keyboard
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    LD_LIBRARY_PATH = "";
  };
  # set pointer cursor due to tiny icon when using scaling
  home.pointerCursor = {
    name = "Pop";
    package = pkgs.pop-icon-theme;
    size = 32;
  };

  # zellij static config file (because limitation in nix to kdl converter)
  xdg.configFile."zellij/config.kdl".source = ../config/zellij.kdl;

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
    gnome-shell = {
      enable = true;
      extensions = with pkgs.gnome42.gnomeExtensions; [
        {package = clipboard-indicator;}
        {package = workspaces-bar;} # deprecated after gnome42
      ];
    };
  };

  # gui programs
  programs = {
    alacritty = (import ../programs/alacritty.nix) {
      inherit pkgs;
      inherit themeColors;
      inherit nixGLWrap;
    };
    thunderbird = {
      enable = true;
      package = nixGLWrap pkgs.thunderbird;
      profiles = {
        default = {
          isDefault = true;
        };
      };
    };
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
      exec = "alacritty";
      exec-arg = "";
    };
    "org/gnome/shell/extensions/clipboard-indicator" = {
      toggle-menu = ["<Super>p"];
    };
  };
}
