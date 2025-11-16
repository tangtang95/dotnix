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
  gitea_port = 8090;
  gitea_mirror_port = 4321;
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
      gitea_port
      gitea_mirror_port
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
      listenPort = 8082;
    in {
      enable = true;
      inherit listenPort;
      openFirewall = true;
      allowedHosts = "${hostname}:${builtins.toString listenPort},${ip_static}:${builtins.toString listenPort}";
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
      # http port: 8096
      enable = true;
      openFirewall = true;
      user = username;
    };
    # bittorrent ui client
    deluge = {
      enable = true;
      web = {
        enable = true;
	port = 8112;
        openFirewall = true;
      };
    };
    # git server
    gitea = {
      enable = true;
      settings = {
        server = {
	  DOMAIN = hostname;
	  DISABLE_SSH = true;
	  HTTP_PORT = gitea_port;
	};
      };
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
      extraGroups = [ 
        "wheel"
        "docker"
      ];
      password = "tangtang";
      shell = pkgs.fish;
    };
  };

  # containers
  system.activationScripts.makeGiteaMirrorDir = lib.stringAfter [ "var" ] ''
    mkdir -p /var/lib/gitea-mirror/data
    chown -R 1000:1000 /var/lib/gitea-mirror
  '';
  virtualisation = {
    oci-containers.containers = {
      "gitea-mirror" = let 
        url = "http://${hostname}:${builtins.toString gitea_mirror_port}";
      in {
        autoStart = true;
	image = "ghcr.io/raylabshq/gitea-mirror:v3.9.2";
	user = "1000:1000";
	ports = [ "${builtins.toString gitea_mirror_port}:4321" ];
	volumes = [ "/var/lib/gitea-mirror/data:/app/data"];
	environment = {
	  BETTER_AUTH_URL = url;
	  BETTER_AUTH_TRUSTED_ORIGINS = url;
	  NODE_ENV = "production";
          DATABASE_URL = "file:/app/data/gitea-mirror.db";
          HOST = "0.0.0.0";
          PORT = "4321";
          PUBLIC_BETTER_AUTH_URL = url;
	};
      };
    };
  };
  
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.05";
}
