{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    neovim
    git
    lazygit
    curl
    wget
    httpie
    tmux
    chezmoi
    gcc
    htop-vim
    ripgrep
    fzf
    fd
    lf
    jq
    age
    gnupg
    zip
    unzip
    atool
  ];
  environment.variables = {
    EDITOR = "nvim";
    PAGER = "less";
  };

  users.users.sunny.initialPassword = "sunny";
  users.users.sunny.isNormalUser = true;
  users.users.sunny.extraGroups = [ "wheel" ];

  services.openssh.enable = true;
  services.cron.enable = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";

}

