# DotNix

Dotfiles for configuring linux environments through nix tools.

## Nix installation

Use determinatate system nix installer since it will also automatically enable flakes experimental feature (https://github.com/DeterminateSystems/nix-installer).

## Usage for NixOS configurations
Manage NixOS configurations with the following command:

```sh
sudo nixos-rebuild switch --flake ~/dotnix
```

NOTE: it will select the correct configuration based on the hostname

## Usage for home configurations

Manage home with the following command:

```sh
nix-shell -p home-manager # required only first time
home-manager switch --flake ~/dotnix
```

### Limitations

#### Change default shell

Add shell program to `/etc/shells` and then change shell. Example with `fish`:

```sh
command -v fish | sudo tee -a /etc/shells
sudo chsh -s "$(command -v fish)" "${USER}"
```

Another way is to change the shell only for the terminal GUI (Recommended way?).

#### Other tweaks

- If there is screen tearing with NVIDIA gpu, enable force composition pipeline
- In order to use VIA keyboard tool, you need to add udev rule for the USB driver keyboard (https://get.vial.today/manual/linux-udev.html)

