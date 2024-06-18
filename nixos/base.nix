{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    wget
    tmux
    chezmoi
  ];

  users.users.sunny.initialPassword = "sunny";
  users.users.sunny.isNormalUser = true;
  users.users.sunny.extraGroups = [ "wheel" ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";

}

