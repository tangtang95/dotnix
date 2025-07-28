{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-gnome-42.url = "github:NixOS/nixpkgs/nixos-22.05"; # For gnome 42 extensions (Pop OS uses gnome 42)
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    nix-gl-host.url = "github:tangtang95/nix-gl-host-rs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    zig-overlay.url = "github:mitchellh/zig-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-gnome-42,
    nixos-wsl,
    home-manager,
    nixgl,
    nix-gl-host,
    rust-overlay,
    zig-overlay,
  }: let
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
    pkgs = import nixpkgs {
      inherit system config;
      overlays = [
        nixgl.overlay
        rust-overlay.overlays.default
        zig-overlay.overlays.default
        nix-gl-host.overlays.default
        (_final: prev: {
          unstable = import nixpkgs-unstable {
            inherit (prev) system;
            inherit config;
          };
          gnome42 = import nixpkgs-gnome-42 {
            inherit (prev) system;
            inherit config;
          };
        })
      ];
    };
  in {
    homeConfigurations."tangtang" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
    nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem {
      inherit system;
      inherit pkgs;
      specialArgs = {
        hostname = "nixos-wsl";
        username = "tangtang";
      };
      modules = [
        nixos-wsl.nixosModules.default
        home-manager.nixosModules.home-manager
        ./systems/wsl/configuration.nix
      ];
    };
    nixosConfigurations.tower-nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      inherit pkgs;
      specialArgs = {
        rootPath = ./.;
      };
      modules = [
        ./systems/tower/configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };
}
