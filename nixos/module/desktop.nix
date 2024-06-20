{ config, lib, pkgs, ... }: {

  users.users.sunny.packages = with pkgs; [
    alacritty
    qutebrowser
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.awesome.enable = true;

}

