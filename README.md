# DotNix

Dotfiles for configuring linux environments through nix home-manager tool.

## My Tower driver to install
 - TP-Link Archer T2U PLUS Wi-Fi driver (RTL8821AU)
   - follow this guide https://github.com/aircrack-ng/rtl8812au but make sure that gcc version is the same as the one used to compile the kernel. At first, the procedure with `kdms` tool did not work, I just did `make && make install`.

## Nix installation
Use determinatate system nix installer since it will also automatically enable flakes experimental feature (https://github.com/DeterminateSystems/nix-installer).

## Usage
Manage home with the following command:
```nix
nix run .#home-manager -- switch --flake ~/dotnix
```
