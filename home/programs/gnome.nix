{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      {package = simple-workspaces-bar;}
      {package = forge;}
      {package = appindicator;}
      {package = disable-workspace-animation;}
    ];
  };

  # only gnome settings
  dconf.settings = {
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
      color-scheme = lib.mkForce "prefer-dark";
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
      command = config.default.terminal;
      binding = "<Super>Return";
    };
    "org/gnome/shell/extensions/forge" = {
      move-pointer-focus-enabled = false;
    };
    "org/gnome/shell/extensions/forge/keybindings" = {
      window-swap-last-active = []; # Remove <Super>Return shortcut
    };
  };
}
