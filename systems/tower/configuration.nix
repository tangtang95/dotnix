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
  ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
      fontSize = 56;
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable Sway Window Manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      xfce.thunar # file explorer
      blueman # bluetooth
      pavucontrol # gui for audio control
      brightnessctl
      grim
      swayidle
      swaylock
      wl-clipboard
      waybar # wayland bar
      xwayland-satellite # x11 in wayland but with correct scaling
      mako # notification system
      libnotify
      pkgs.unstable.rofi #TODO: remove unstable for 2.0.0 that supports wayland when available in stable
    ];
    xwayland.enable = true;
  };
  services.gnome.gnome-keyring.enable = true;

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
    users.${username} = import ../../home/home.nix;
    extraSpecialArgs = {
      inherit pkgs;
      username = "${username}";
      installGui = true;
    };
  };

  programs = {
    firefox.enable = true;
    neovim.enable = true;
    fish.enable = true;
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
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    via
  ];
  environment.sessionVariables = {
    NVIM_USE_NIXOS_MODULE = "true";
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
