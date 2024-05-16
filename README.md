# DotNix

Dotfiles for configuring linux environments through nix home-manager tool.

## My Tower Desktop PC driver to install

 - TP-Link Archer T2U PLUS Wi-Fi driver (RTL8821AU)
   - follow this guide https://github.com/aircrack-ng/rtl8812au but make sure that gcc version is the same as the one used to compile the kernel. At first, the procedure with `kdms` tool did not work (it broke the kernel or something), I just did `make && make install`.

## Nix installation

Use determinatate system nix installer since it will also automatically enable flakes experimental feature (https://github.com/DeterminateSystems/nix-installer).

## Usage

Manage home with the following command:

```sh
nix run .#home-manager -- switch --impure --flake ~/dotnix

# after one generation of home manager, it is possible to use home-manager directly
home-manager switch --impure --flake ~/dotnix
```

### Limitations

- Determinism due to impure evaluation mode. Impure is necessary due to limitation of nixGL (i.e. builtins.currentTime https://github.com/NixOS/nix/issues/3539)

## Change default shell

Add shell program to `/etc/shells` and then change shell. Example with `fish`:

```sh
command -v fish | sudo tee -a /etc/shells
sudo chsh -s "$(command -v fish)" "${USER}"
```

## Other tools to install

- Steam with Proton
- Spotify (log in via Browser does not work if installed via nix)

## Other tweaks

- If there is screen tearing with NVIDIA gpu, enable force composition pipeline
