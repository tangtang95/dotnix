{
  pkgs,
  username,
  ...
}: {
  # Add user to libvirtd group
  users.groups.libvirtd.members = ["${username}"];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-viewer
    spice-protocol
    virtio-win
    win-spice
  ];

  programs = {
    dconf.enable = true;
    virt-manager.enable = true;
  };

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        vhostUserPackages = with pkgs; [
          virtiofsd # filesystem sharing
        ];
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
}
