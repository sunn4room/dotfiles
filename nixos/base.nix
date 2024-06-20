{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    wget
    tmux
    chezmoi
    gcc
    htop-vim
    ripgrep
    fzf
    fd
    lf
    jq
  ];

  users.users.sunny.initialPassword = "sunny";
  users.users.sunny.isNormalUser = true;
  users.users.sunny.extraGroups = [ "wheel" ];

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";

}

