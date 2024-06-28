{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    alacritty
    qutebrowser
    xorg.libxcvt
    xsel
    gtk3
    clipit
    picom
    libnotify
    i3lock
    xautolock
    brightnessctl
    dunst
    feh
    mpv
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    jetbrains-mono
    capitaine-cursors
    intel-gpu-tools
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      libsForQt5.fcitx5-chinese-addons
    ];
  };

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.awesome.enable = true;
  hardware.pulseaudio.enable = true;

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrains Mono NL"
          "Noto Sans Mono CJK SC"
          "Noto Sans Mono CJK TC"
          "Noto Sans Mono CJK JP"
          "Noto Sans Mono CJK KR"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
          "Noto Sans CJK TC"
          "Noto Sans CJK JP"
          "Noto Sans CJK KR"
        ];
        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
          "Noto Serif CJK TC"
          "Noto Serif CJK JP"
          "Noto Serif CJK KR"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

}
