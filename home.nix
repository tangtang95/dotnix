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
       echo "exec ${lib.getExe' pkgs.nixgl.auto.nixGLDefault "nixGL"} $bin \"\$@\"" > $wrapped_bin
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
  home.stateVersion = "23.11";
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
    pkgs.rust-bin.stable.latest.complete
    (pkgs.python3.withPackages (ps: with ps; [pip]))
    (pkgs.lua.withPackages (ps: with ps; [jsregexp]))
    pkgs.gnumake
    pkgs.nodejs

    # cargo packages
    pkgs.cargo-llvm-cov

    # language tools
    pkgs.tree-sitter

    # formatters
    pkgs.alejandra

    # dap (debugger tool)
    pkgs.vscode-extensions.vadimcn.vscode-lldb

    # others
    pkgs.fzf
    pkgs.neofetch
    pkgs.tealdeer
    pkgs.xclip
    pkgs.xdg-utils
    pkgs.watchexec
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})

    # guis
    pkgs.nixgl.auto.nixGLDefault
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # zellij static config file (because limitation in nix to kdl converter)
  xdg.configFile."zellij/config.kdl".source = ./config/zellij.kdl;

  # enable user fonts
  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza = {
      enable = true;
      enableAliases = true;
      icons = true;
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
    broot = {
      enable = true;
    };
    git = import ./programs/git.nix;
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
  };

  # gui programs
  programs = {
    alacritty = (import ./programs/alacritty.nix) {
      inherit pkgs;
      inherit themeColors;
      inherit nixGLWrap;
    };
    thunderbird = {
      enable = true;
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
      move-to-workspace-1 = ["<Shift><Super>exclam"];
      move-to-workspace-2 = ["<Shift><Super>quotedbl"];
      move-to-workspace-3 = ["<Shift><Super>sterling"];
      move-to-workspace-4 = ["<Shift><Super>dollar"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
    };
    "org/gnome/desktop/applications/terminal" = {
      exec = "alacritty";
      exec-arg = "";
    };
  };
}
