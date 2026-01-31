{
  pkgs,
  config,
  lib,
  username,
  installGui ? true,
  ...
}: {
  imports =
    [
      ./options.nix
      ./programs/git.nix
    ]
    ++ (
      if installGui
      then [
        ./programs/sway.nix
        ./programs/waybar.nix
        ./programs/common-gui.nix
        ./programs/rclone.nix # TODO: move it to default imports when ready
      ]
      else []
    );

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
  home.keyboard = {
    layout = "us";
  };
  home.packages = with pkgs; [
    # new coreutils
    ripgrep
    ripgrep-all
    fd
    bottom
    dust
    sd
    procs
    tailspin

    # web tools
    wget
    httpie
    termscp
    dogdns
    bandwhich

    # file processors
    jq
    jqp
    yq
    zip
    unzip
    hexyl

    # text editors
    vim
    delta

    # languages
    (rust-bin.stable.latest.default.override {
      extensions = ["rust-analyzer" "rust-src" "llvm-tools"];
      targets = ["i686-pc-windows-msvc"];
    })
    zigpkgs."0.15.2"
    (python3.withPackages (ps: with ps; [pip]))
    (lua51Packages.lua.withPackages (ps: with ps; [jsregexp luarocks]))
    gnumake
    nodejs
    go
    typst
    gcc

    # lsp only for nixos
    nixd
    gopls
    zls
    lua-language-server
    marksman

    # formatters only for nixos
    alejandra

    # language tools
    tree-sitter

    # dap (debugger tool)
    vscode-extensions.vadimcn.vscode-lldb
    lldb

    # benchmarking tools
    samply
    hyperfine

    # ai
    unstable.opencode

    # others
    presenterm
    python313Packages.weasyprint # for presenterm export pdf
    just
    fastfetch # fetch OS info
    onefetch # fetch git info
    tokei
    onefetch
    tealdeer
    wl-clipboard
    xdg-utils
    watchexec
    nerd-fonts.jetbrains-mono
  ];
  home.sessionVariables = {
    BROWSER = config.default.browser;
    TERMINAL = config.default.terminal;
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
  };

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      shellAliases = {
        pbcopy = "wl-copy";
        pbpaste = "wl-paste";
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
    bat.enable = true;
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
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
    zellij = {
      enable = true;
      enableFishIntegration = true;
    };
    yazi = {
      enable = true;
      enableFishIntegration = true;
    };
    lazygit.enable = true;
    btop.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
