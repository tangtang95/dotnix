# DotNix

Dotfiles for configuring linux environments through nix home-manager tool.

## My Tower Desktop PC driver to install

 - TP-Link Archer T2U PLUS Wi-Fi driver (RTL8821AU)
   - follow this guide https://github.com/aircrack-ng/rtl8812au but make sure that gcc version is the same as the one used to compile the kernel.
   - Working commit hash version: https://github.com/aircrack-ng/rtl8812au/tree/63cf0b4584aa8878b0fe8ab38017f31c319bde3d 

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
- Require to use firefox installed via nix and using nixGL. Otherwise other nix GUI apps that need to open web pages will not work

## Change default shell

Add shell program to `/etc/shells` and then change shell. Example with `fish`:

```sh
command -v fish | sudo tee -a /etc/shells
sudo chsh -s "$(command -v fish)" "${USER}"
```

## Other tools to install

- Steam with Proton

## Other tweaks

- If there is screen tearing with NVIDIA gpu, enable force composition pipeline
- In order to use VIA keyboard tool, you need to add udev rule for the USB driver keyboard (https://get.vial.today/manual/linux-udev.html)
