{ config, lib, pkgs, inputs, ... }: {

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
      };
    })
  ];

  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.timeout = 15;
  boot.supportedFilesystems = [ "xfs" "vfat" ];

  environment.systemPackages = with pkgs; [
    gcc
    lldb
    shellcheck-minimal
    shfmt
    go
    gopls
    delve
    rustc
    cargo
    cargo-nextest
    rust-analyzer
    rustfmt
    (python3.withPackages (python-pkgs: with python-pkgs; [
      requests
      psutil
      pip
    ]))
    nodePackages.nodejs
    lua51Packages.lua
    lua-language-server
    stylua
    taplo
    file
    helix
    unstable.neovim
    git
    lazygit
    curl
    wget
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
    mitmproxy
    exiftool
    ffmpeg
  ];
  environment.variables = {
    EDITOR = "nvim";
    PAGER = "less";
    FZF_DEFAULT_OPTS = ''
      --ansi
      --no-unicode
      --algo=v1
      --tiebreak=chunk,begin,length,index
      --layout=reverse
      --info=inline
      --no-separator
      --color=fg:white,hl:magenta,fg+:bright-white,bg+:-1,hl+:bright-magenta
      --color=prompt:green,query:bright-white,info:cyan,pointer:bright-magenta,marker:magenta,header:blue,spinner:red
      --bind="change:first,tab:down,btab:up"
    '';
    FZF_DEFAULT_COMMAND = "fd -H -L --strip-cwd-prefix";
  };
  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PYTHONPATH = "$HOME/.python-packages";
	GO111MODULE = "on";
	GOPROXY = "https://goproxy.cn";
    PATH = [
      "${XDG_BIN_HOME}"
      "$HOME/.cargo/bin"
      "$HOME/.npm-global/bin"
      "$HOME/.python-packages/bin"
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

  virtualisation.podman.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";

}

