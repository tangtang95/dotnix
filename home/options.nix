{
  pkgs,
  lib,
  ...
}:
with lib; let
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in {
  options = {
    default = {
      terminal = mkOption {
        type = types.str;
        default = "alacritty";
        description = "The default terminal emulator to use across the system.";
      };
      audioToggleCommand = mkOption {
        type = types.str;
        default = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
      audioRaiseCommand = mkOption {
        type = types.str;
        default = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1";
      };
      audioLowerCommand = mkOption {
        type = types.str;
        default = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      };
      fontMonoNerd = mkOption {
        type = types.str;
        default = "JetBrainsMono Nerd Font Mono";
      };
    };
  };
}
