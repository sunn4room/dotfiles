{ config, lib, pkgs, ... }: {

  boot.loader.systemd-boot.configurationLimit = 2;
  boot.supportedFilesystems = [ "xfs" "vfat" ];

  environment.systemPackages = with pkgs; [
    gcc
    (python3.withPackages (python-pkgs: [
      python-pkgs.requests
    ]))
    neovim
    git
    lazygit
    curl
    wget
    httpie
    tmux
    chezmoi
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
  users.users.guest.initialPassword = "guest";
  users.users.guest.isNormalUser = true;

  security.sudo.extraRules = [
    {
      users = [ "sunny" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl poweroff";
          options = [ "SETENV" "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl reboot";
          options = [ "SETENV" "NOPASSWD" ];
        }
      ];
    }
  ];

  services.openssh.enable = true;
  services.cron.enable = true;

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";

}

