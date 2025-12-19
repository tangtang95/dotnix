{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotnixvim.url = "github:tangtang95/dotnixvim";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nix-gl-host.url = "github:tangtang95/nix-gl-host-rs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      stylix,
      dotnixvim,
      nixos-wsl,
      nix-gl-host,
      rust-overlay,
      zig-overlay,
      ...
    }:
    let
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
      username = "tangtang";
      pkgs = import nixpkgs {
        inherit system config;
        overlays = [
          rust-overlay.overlays.default
          zig-overlay.overlays.default
          nix-gl-host.overlays.default
          (_final: prev: {
            unstable = import nixpkgs-unstable {
              # TODO: fix system deprecation https://discourse.nixos.org/t/how-to-fix-evaluation-warning-system-has-been-renamed-to-replaced-by-stdenv-hostplatform-system/72120/1
              # after other overlays has also fixed it
              inherit (prev) system;
              inherit config;
            };
          })
        ];
      };
    in
    {
      # home config for steamdeck
      homeConfigurations.deck = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          username = "deck";
          installGui = false;
        };
        modules = [
          stylix.homeModules.stylix
          ./home/deck.nix
        ];
      };
      nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          hostname = "nixos-wsl";
          inherit username;
          inherit stylix;
        };
        modules = [
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          dotnixvim.nixosModules.default
          ./systems/wsl/configuration.nix
        ];
      };
      nixosConfigurations.tower-nixos = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = {
          username = "tangtang-tower";
        };
        modules = [
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          dotnixvim.nixosModules.default
          ./systems/tower/configuration.nix
        ];
      };
      # raspberry-pi4b as home server
      nixosConfigurations.home-server =
        let
          system = "aarch64-linux";
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (_final: prev: {
                unstable = import nixpkgs-unstable {
                  inherit (prev) system;
                };
              })
            ];
          };
          specialArgs = {
            hostname = "home-server";
            inherit username;
          };
          modules = [ ./systems/pi4b/configuration.nix ];
        };
    };
}
