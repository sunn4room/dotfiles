{ config, lib, pkgs, ... }: {

  imports = [
    ./vbox.nix
    ./module/desktop.nix
  ];

  networking.hostName = lib.mkForce "vbox-desktop";
  services.xserver.resolutions = [
    {
      x = 1366;
      y = 768;
    }
  ];

}

