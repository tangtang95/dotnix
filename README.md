# DotNix

Dotfiles for configuring linux environments through nix home-manager tool.

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
- virt-manager with kvm (https://ipv6.rs/tutorial/POP!_OS_Latest/KVM/)

## Other tweaks

- If there is screen tearing with NVIDIA gpu, enable force composition pipeline
- In order to use VIA keyboard tool, you need to add udev rule for the USB driver keyboard (https://get.vial.today/manual/linux-udev.html)
