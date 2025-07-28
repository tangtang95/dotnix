{
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = "${username}";
    wslConf.interop.appendWindowsPath = false;
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''set fish_greeting'';
    };
  };

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
