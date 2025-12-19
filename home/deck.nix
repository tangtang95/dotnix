{
  pkgs,
  lib,
  config,
  ...
}: let
  # wrapper code obtained from: https://github.com/nix-community/home-manager/blob/master/modules/misc/nixgl.nix#L212
  makePackageWrapper = pkg: (pkg.overrideAttrs (old: {
    name = "nixGL-${pkg.name}";
    separateDebugInfo = false;
    nativeBuildInputs = old.nativeBuildInputs or [] ++ [pkgs.makeWrapper];
    buildCommand = ''
      set -eo pipefail

      ${
        # Heavily inspired by https://stackoverflow.com/a/68523368/6259505
        lib.concatStringsSep "\n" (
          map (outputName: ''
            echo "Copying output ${outputName}"
            set -x
            cp -rs --no-preserve=mode "${pkg.${outputName}}" "''$${outputName}"
            set +x
          '') (old.outputs or ["out"])
        )
      }

      rm -rf $out/bin/*
      shopt -s nullglob # Prevent loop from running if no files
      for file in ${pkg.out}/bin/*; do
        local prog="$(basename "$file")"
        makeWrapper \
          "${lib.getExe pkgs.nix-gl-host}" \
          "$out/bin/$prog" \
          --argv0 "$prog" \
          --add-flags "$file"
      done

      # If .desktop files refer to the old package, replace the references
      for dsk in "$out/share/applications"/*.desktop ; do
        if ! grep -q "${pkg.out}" "$dsk"; then
          continue
        fi
        src="$(readlink "$dsk")"
        rm "$dsk"
        sed "s|${pkg.out}|$out|g" "$src" > "$dsk"
      done

      shopt -u nullglob # Revert nullglob back to its normal default state
    '';
  }));
in {
  imports = [
    ./home.nix
  ];
  home.pointerCursor = lib.mkForce {
    enable = true;
    name = "breeze-dark";
    package = pkgs.kdePackages.breeze;
    size = 24;
  };
  home.packages = with pkgs; [
    patchelf
    nix-gl-host
    xclip
    (makePackageWrapper spotify)
    (makePackageWrapper discord)
  ];
  home.keyboard = {
    layout = "us";
    options = ["caps:swapescape"];
  };
  programs = {
    fish = {
      shellAliases = {
        pbcopy = lib.mkForce "xclip";
        pbpaste = lib.mkForce "xclip -o";
      };
    };
    alacritty = {
      enable = true;
      package = makePackageWrapper pkgs.alacritty;
      theme = "catppuccin_mocha";
      settings = {
        terminal = {
          shell = "fish";
        };
      };
    };
    ghostty = {
      enable = true;
      package = makePackageWrapper pkgs.ghostty;
      settings = {
        theme = "Catppuccin Mocha";
        font-family = "JetBrainsMono Nerd Font Mono";
        confirm-close-surface = false;
        cursor-style = "block";
        shell-integration-features = "no-cursor";
      };
    };
  };

  systemd.user = {
    services = lib.mkIf (config.home.keyboard != null) {
      setxkbmap = {
        Unit = {
          Description = "Set up keyboard in X";
          After = ["graphical-session-pre.target"];
          PartOf = ["graphical-session.target"];
        };

        Install = {
          WantedBy = ["graphical-session.target"];
        };

        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = with config.home.keyboard; let
            args =
              lib.optional (layout != null) "-layout '${layout}'"
              ++ lib.optional (variant != null) "-variant '${variant}'"
              ++ lib.optional (model != null) "-model '${model}'"
              ++ ["-option ''"]
              ++ map (v: "-option '${v}'") options;
          in "${pkgs.xorg.setxkbmap}/bin/setxkbmap ${toString args}";
        };
      };
    };
  };
}
