{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixgl.url = "github:nix-community/nixGL";
    rust-overlay.url = "github:oxalica/rust-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixgl, rust-overlay }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
	overlays = [ nixgl.overlay rust-overlay.overlays.default ];
	config.allowUnfree = true;
      };
    in {
      homeConfigurations."tangtang" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      inherit home-manager;
      inherit (home-manager) packages;
    };
}
