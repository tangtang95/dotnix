{
  pkgs,
  lib,
  username,
  ...
}: {
  home.packages = [
    pkgs.rclone
  ];

  systemd.user = let
    remote-name = "google-drive";
    remote-mount-path = "/";
    local-mount-point = "/home/${username}/cloud/${remote-name}";
  in {
    timers = {
      "rclone-sync@${remote-name}" = {
        Unit = {
          Description = "Rclone Timer job for ${remote-name}:${remote-mount-path}";
        };
        Timer = {
          OnBootSec = "1min";
          OnUnitActiveSec = "1h";
        };

        Install.WantedBy = ["timers.target"];
      };
    };
    services = {
      "rclone-sync@${remote-name}" = {
        Unit = {
          Description = "Rclone sync service for ${remote-name}:${remote-mount-path}";
        };
        Service = {
          Environment = [
            # fusermount/fusermount3
            "PATH=/run/wrappers/bin"
          ];
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${local-mount-point}";
          ExecStart = lib.concatStringsSep " " [
            "${pkgs.rclone}/bin/rclone"
            "sync"
            "-vv"
            "${remote-name}:${remote-mount-path}"
            "${local-mount-point}"
          ];
        };
      };
    };
  };
}
