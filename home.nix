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
            activeBorderColor = ["#89b4fa" "bold"];
            inactiveBorderColor = ["#a6adc8"];
            optionsTextColor = ["#89b4fa"];
            selectedLineBgColor = ["#313244"];
            cherryPickedCommitBgColor = ["#45475a"];
            cherryPickedCommitFgColor = ["#89b4fa"];
            unstagedChangesColor = ["#f38ba8"];
            defaultFgColor = ["#cdd6f4"];
            searchingActiveBorderColor = ["#f9e2af"];
          };
          authorColors = {
            "Tangtang Zhou" = "#cba6f7";
            "*" = "#b4befe";
          };
        };
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
    alacritty = {
      enable = true;
      package = nixGLWrap pkgs.alacritty;
      settings = {
        shell = "fish";
        window.dimensions = {
          columns = 100;
          lines = 25;
        };
        font.normal.family = "JetBrainsMono Nerd Font";
        font.size = 12;
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:swapescape"];
    };
  };
}
