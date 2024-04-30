# DotNix

Dotfiles for configuring linux environments through nix home-manager tool.

## My Tower Desktop PC driver to install
 - TP-Link Archer T2U PLUS Wi-Fi driver (RTL8821AU)
   - follow this guide https://github.com/aircrack-ng/rtl8812au but make sure that gcc version is the same as the one used to compile the kernel. At first, the procedure with `kdms` tool did not work (it broke the kernel or something), I just did `make && make install`.

## Nix installation
Use determinatate system nix installer since it will also automatically enable flakes experimental feature (https://github.com/DeterminateSystems/nix-installer).

## Other installations
Install OpenGL GUI that does not work well with nix non-NixOS such as:
```sh
sudo apt install alacritty
```

## Usage
Manage home with the following command:
```sh
nix run .#home-manager -- switch --flake ~/dotnix

# after one generation of home manager, it is possible to use home-manager directly
home-manager switch --flake ~/dotnix
```
