{
  pkgs,
  lib,
  ...
}:
with lib; let
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in {
  options.defaultTerminal = mkOption {
    type = types.str;
    default = "alacritty";
    description = "The default terminal emulator to use across the system.";
  };
  options.audioToggleCommand = mkOption {
    type = types.str;
    default = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
  };
  options.audioRaiseCommand = mkOption {
    type = types.str;
    default = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1";
  };
  options.audioLowerCommand = mkOption {
    type = types.str;
    default = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
  };
  options.fontMonoNerd = mkOption {
    type = types.str;
    default = "JetBrainsMono Nerd Font Mono";
  };
  options.nixGLWrap = mkOption {
    type = types.str || types.null ;
    default = null;
  };
}
