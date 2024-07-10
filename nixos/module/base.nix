{ config, lib, pkgs, ... }: {

  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.timeout = 15;
  boot.supportedFilesystems = [ "xfs" "vfat" ];

  environment.systemPackages = with pkgs; [
    gcc
    (python3.withPackages (python-pkgs: with python-pkgs; [
      requests
      psutil
    ]))
    nodejs_22
    neovim
    nvimpager
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
    rclone
    sqlite
    peaclock
  ];
  environment.variables = {
    EDITOR = "nvim";
    PAGER = "nvimpager";
    FZF_DEFAULT_OPTS = ''
      --ansi
      --algo=v1
      --tiebreak=chunk,begin,length,index
      --layout=reverse
      --info=inline
      --no-separator
      --color=fg:white,hl:magenta,fg+:bright-white,bg+:-1,hl+:bright-magenta
      --color=prompt:green,query:bright-white,info:cyan,pointer:bright-magenta,marker:magenta,header:blue,spinner:red
      --bind="change:first,tab:down,btab:up"
    '';
    FZF_DEFAULT_COMMAND = ''
      fd -H -L
      --strip-cwd-prefix
      --exclude={.git,.idea,.cache,.sass-cache,node_modules,.npm,build,target}
    '';
  };
  environment.sessionVariables = rec {
    XDG_CACHE_HOME  = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    XDG_BIN_HOME    = "$HOME/.local/bin";
    PATH = [ 
      "${XDG_BIN_HOME}"
    ];
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
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";

}

