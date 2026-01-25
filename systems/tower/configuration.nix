# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  username,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../virtualization.nix
  ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      font = lib.mkForce "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
      fontSize = lib.mkForce 56;
      # windows entry obtained by option `useOSProber = true;` avoid using useOSProber to speed up nixos rebuild
      extraEntries = ''
        menuentry 'Windows 11' --class windows --class os $menuentry_id_option 'osprober-efi-6E0F-9C7C' {
          insmod part_gpt
          insmod fat
          set root='hd1,gpt1'
          if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-ieee1275='ieee1275//disk@0,gpt1' --hint-bios=hd1,gpt1 --hint-efi=hd1,gpt1 --hint-baremetal=ahci1,gpt1  6E0F-9C7C
          else
            search --no-floppy --fs-uuid --set=root 6E0F-9C7C
          fi
          chainloader /efi/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  # Use nix flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "tower-nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";
  # Avoid windows incorrect clock by sharing same clock
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable greeter with sway
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --user-menu --remember --asterisks --cmd sway";
        user = "greeter";
      };
    };
  };
  # NOTE: override greetd service to avoid error logs on screen
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # avoid error logs on screen

    # Avoid boot logs on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Enable Sway Window Manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      blueman # bluetooth
      pavucontrol # gui for audio control
      brightnessctl
      grim
      swayidle
      swaylock
      wl-clipboard
      waybar # wayland bar
      mako # notification system
      libnotify
      rofi
    ];
    xwayland.enable = false;
  };
  services.gnome.gnome-keyring.enable = true;
  security.polkit = {
    enable = true;
    extraConfig = ''
      // polkit rule for file manager mounting using udisks2
      polkit.addRule(function(action, subject) {
        var YES = polkit.Result.YES;
        // NOTE: there must be a comma at the end of each line except for the last:
        var permission = {
          "org.freedesktop.udisks2.filesystem-mount": YES,
          "org.freedesktop.udisks2.encrypted-unlock": YES,
          "org.freedesktop.udisks2.eject-media": YES,
          "org.freedesktop.udisks2.power-off-drive": YES,
          // For file manager
          "org.freedesktop.udisks2.filesystem-mount-system": YES
        };
        if (subject.isInGroup("wheel")) {
          return permission[action.id];
        }
      });
    '';
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # For keychron keyboard detection
  hardware.keyboard.qmk.enable = true;
  services.udev = {
    packages = with pkgs; [
      qmk-udev-rules
      via
    ];
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "Tangtang";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
  };
  home-manager = {
    users.${username}.imports = [
      ../../home/stylix.nix
      ../../home/home.nix
    ];
    extraSpecialArgs = {
      inherit pkgs;
      username = "${username}";
      installGui = true;
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    targets = {
      grub.enable = false;
    };
  };

  programs = {
    # default gui apps
    firefox.enable = true;
    neovim.enable = true;

    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            adwaita-icon-theme
          ];
      };
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    };
    fish.enable = true;
    command-not-found.enable = false; # Does not work on nixos with flakes
    # gnome settings for all
    dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            scaling-factor = lib.gvariant.mkUint32 2; # for log-in screen
          };
        };
      }
    ];
    nixvim = {
      enable = true;
    };
  };
  services.gvfs.enable = true; # gnome virtual file system for file manager

  # Set default terminal app
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = ["alacritty.desktop"];
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # default gui apps
    loupe # image viewer
    decibels # audio player
    showtime # media player
    papers # pdf viewer
    snapshot # camera
    gnome-calculator
    libreoffice
    file-roller # archive manager

    # dolphin with open app fix https://github.com/rumboon/dolphin-overlay/blob/main/default.nix
    (kdePackages.overrideScope (kfinal: kprev: {
      dolphin = kprev.dolphin.overrideAttrs (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
        postInstall =
          (oldAttrs.postInstall or "")
          + ''
            wrapProgram $out/bin/dolphin \
                --set XDG_CONFIG_DIRS "${pkgs.libsForQt5.kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
                --run "${kprev.kservice}/bin/kbuildsycoca6 --noincremental ${pkgs.libsForQt5.kservice}/etc/xdg/menus/applications.menu"
          '';
      });
    })).dolphin
    kdePackages.qtsvg
    kdePackages.kio
    kdePackages.kio-fuse
    kdePackages.kio-extras

    wget
    via
  ];
  environment.sessionVariables = {
    NVIM_USE_NIXOS_MODULE = "true";
    NIXOS_OZONE_WL = "1"; #NOTE: for electron and chromium app to use wayland
    _JAVA_AWT_WM_NONREPARENTING = "1"; #NOTE: fix java apps in wayland
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  xdg.mime = {
    enable = true;
    defaultApplications = let
      fileManagerApp = "org.kde.dolphin.desktop";
      imageViewerApp = "org.gnome.Loupe.desktop";
      emailApp = "userapp-Thunderbird-PB4G92.desktop";
      archiverApp = "org.gnome.FileRoller.desktop";
      textApp = "nvim.desktop";
    in {
      "inode/directory" = fileManagerApp;
      "inode/mount-point" = fileManagerApp;
      "application/x-zip" = archiverApp;
      "application/x-gzip" = archiverApp;
      "application/x-lzip" = archiverApp;
      "application/x-tar" = archiverApp;
      "application/x-compressed-tar" = archiverApp;
      "application/pdf" = "org.gnome.Papers.desktop";
      "text/plain" = textApp;
      "text/x-log" = textApp;
      "x-scheme-handler/mailto" = emailApp;
      "message/rfc822" = emailApp;
      "x-scheme-handler/mid" = emailApp;
      "image/jpeg" = imageViewerApp;
      "image/png" = imageViewerApp;
      "image/gif" = imageViewerApp;
      "image/webp" = imageViewerApp;
      "image/tiff" = imageViewerApp;
      "image/x-tga" = imageViewerApp;
      "image/vnd-ms.dds" = imageViewerApp;
      "image/x-dds" = imageViewerApp;
      "image/bmp" = imageViewerApp;
      "image/vnd.microsoft.icon" = imageViewerApp;
      "image/vnd.radiance" = imageViewerApp;
      "image/x-exr" = imageViewerApp;
      "image/x-portable-bitmap" = imageViewerApp;
      "image/x-portable-graymap" = imageViewerApp;
      "image/x-portable-pixmap" = imageViewerApp;
      "image/x-portable-anymap" = imageViewerApp;
      "image/x-qoi" = imageViewerApp;
      "image/qoi" = imageViewerApp;
      "image/svg+xml" = imageViewerApp;
      "image/svg+xml-compressed" = imageViewerApp;
      "image/avif" = imageViewerApp;
      "image/heic" = imageViewerApp;
      "image/jxl" = imageViewerApp;
    };
  };

  # Automatic garbage collection of nix store
  nix.gc = {
    automatic = false;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
