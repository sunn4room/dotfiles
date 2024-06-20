{ config, lib, pkgs, ... }: {

  imports = [
    ./vbox.nix
    ./module/desktop.nix
  ];

  networking.hostName = lib.mkForce "vbox-desktop";

}

