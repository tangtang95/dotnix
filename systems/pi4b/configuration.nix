{
  config,
  pkgs,
  lib,
  hostname,
  username,
  ...
}:
let
  ip_static = "192.168.1.251";
in
{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/mnt/passdrive" = {
      device = "/dev/disk/by-uuid/ddb9e481-e4a5-4e43-b17b-2c0f853e73c5";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail"
        "X-mount.owner=${username}"
        "X-mount.group=users"
        "X-mount.mode=0766"
      ];
      depends = [ "/" ];
    };
  };

  networking = {
    hostName = hostname;
    firewall.allowedTCPPorts = [
      53
      8123
      8080
      8443
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    fastfetch
    speedtest-cli
  ];

  services = {
    openssh.enable = true;
    homepage-dashboard = let 
      homepage-dashboard-port = "8082";
    in {
      enable = true;
      openFirewall = true;
      allowedHosts = "${hostname}:${homepage-dashboard-port},${ip_static}:${homepage-dashboard-port}";
      widgets = [
        {
          resources = {
            label = "system";
            uptime = true;
            cpu = true;
            memory = true;
            cputemp = true;
            units = "metric";
            network = true;
          };
        }
      ];
    };
    # media server
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = username;
    };
    # bittorrent ui client
    deluge = {
      enable = true;
      web.enable = true;
      web.openFirewall = true;
    };
    adguardhome = {
      enable = false;
      openFirewall = true;
      settings = {
        dns = {
          bind_hosts = [ "0.0.0.0" ];
          port = 53;
          upstream_dns = [
            "1.1.1.1" # cloudflare
            "8.8.8.8" # google
          ];
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          parental_enabled = false;
          safe_search.enabled = false;
        };
        filters =
          map
            (url: {
              enabled = true;
              url = url;
            })
            [
              # The Big List of Hacked Malware Web Sites
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
              # malicious url blocklist
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
              # HaGeZi's Ultimate DNS Blocklist
              "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/ultimate.txt"
            ];
      };
    };
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
    git = {
      enable = true;
      config = {
        user = {
          name = "Tangtang Zhou";
          email = "tangtang2995@gmail.com";
        };
        core = {
          editor = "nvim";
        };
        alias = {
          pfl = "push --force-with-lease";
          log1l = "log --oneline";
          logp = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
          branch-merged = "!git branch --merged | grep  -v '\\*\\|master\\|main'";
        };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        pull = {
          rebase = true;
        };
        init = {
          defaultBranch = "main";
        };
        credential.helper = "store";
      };
    };
  };

  users = {
    mutableUsers = false;
    users."${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "tangtang";
      shell = pkgs.fish;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";
}
