{
  config,
  lib,
  pkgs,
  username,
  hostname,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = "${username}";
    wslConf = {
      interop.appendWindowsPath = false;
    };
  };

  networking.hostName = "${hostname}";

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''set fish_greeting'';
    };
  };

  environment.systemPackages = [];

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
    ];
  };

  home-manager = {
    users.tangtang.imports = [
      ../../home/home.nix
    ];
    extraSpecialArgs = {
      inherit pkgs;
      username = "tangtang";
      installGui = false;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.05";
}
