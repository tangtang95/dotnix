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
    pkgs.fd
    pkgs.bat
    pkgs.bottom
    pkgs.du-dust
    pkgs.sd
    pkgs.procs

    # web tools
    pkgs.wget
    pkgs.httpie
    pkgs.termscp

    # file processors
    pkgs.jq
    pkgs.jqp
    pkgs.yq
    pkgs.zip
    pkgs.unzip

    # text editors
    pkgs.vim
    pkgs.delta

    # languages
    pkgs.rust-bin.stable.latest.default
    (pkgs.python3.withPackages (ps: with ps; [pip]))
    (pkgs.lua.withPackages (ps: with ps; [jsregexp]))
    pkgs.gnumake
    pkgs.nodejs

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
    pkgs.wl-clipboard
    pkgs.xdg-utils
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
    pkgs.nixgl.auto.nixGLDefault
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # zellij static config file (because limitation in nix to kdl converter)
  xdg.configFile."zellij/config.kdl".source = ./config/zellij.kdl;
  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
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
    git = {
      enable = true;
      userName = "Tangtang Zhou";
      userEmail = "tangtang2995@gmail.com";
      aliases = {
        pfl = "push --force-with-lease";
        log1l = "log --oneline";
      };
      delta = {
        enable = true;
      };
      extraConfig = {
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        pull = {
          rebase = true;
        };
        merge.tool = "nvimdiff";
        mergetool = {
          prompt = false;
          keepBackup = false;
        };
        "mergetool \"vimdiff\"".layout = "LOCAL,MERGED,REMOTE";
        init = {
          defaultBranch = "main";
        };
        credential.helper = "store";
      };
    };
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
    alacritty = (import ./programs/alacritty.nix) {
      inherit pkgs;
      inherit themeColors;
      inherit nixGLWrap;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:swapescape"];
    };
  };
}
