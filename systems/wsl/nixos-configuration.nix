{ config, lib, pkgs, username, ...}: 

{
  wsl.enable = true;
  wsl.defaultUser = "nixos";

  programs = {
    fish = {
      enable = true;
      package = pkgs.unstable.fish;
      interactiveShellInit = ''set fish_greeting'';
    };
    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
    starship = {
      enable = true;
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
  
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";
}
