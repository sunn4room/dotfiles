{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    alacritty
    microsoft-edge
    zathura
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
    xflux
    flameshot
    neovide
    appimage-run
  ];

  environment.variables = {
    TERMINAL = "alacritty";
    GTK_THEME = "Adwaita:dark";
  };

  qt.enable = true;
  qt.style = "adwaita-dark";

  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [
    fcitx5-gtk
    libsForQt5.fcitx5-qt
    libsForQt5.fcitx5-chinese-addons
  ];

  services.xserver.enable = true;
  services.xserver.dpi = 120;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme.name = "capitaine-cursors-white";
  services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme.size = 32;
  services.xserver.displayManager.lightdm.greeters.gtk.indicators = [ "~host" "~spacer" "~power" ];
  services.xserver.displayManager.lightdm.greeters.gtk.extraConfig = "font-name = monospace 10";
  services.xserver.windowManager.awesome.enable = true;
  hardware.pulseaudio.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    jetbrains-mono
    (nerdfonts.override {
      fonts = [ "Noto" "JetBrainsMono" ];
      fetchurl = { url, sha256 } : builtins.fetchurl {
        url = "https://mirror.ghproxy.com/${url}";
        inherit sha256;
      };
    })
  ];
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [
    "JetBrainsMonoNL Nerd Font"
    "NotoSansM Nerd Font"
    "Noto Sans Mono CJK SC"
    "Noto Sans Mono CJK TC"
    "Noto Sans Mono CJK JP"
    "Noto Sans Mono CJK KR"
  ];
  fonts.fontconfig.defaultFonts.sansSerif = [
    "NotoSans Nerd Font"
    "Noto Sans CJK SC"
    "Noto Sans CJK TC"
    "Noto Sans CJK JP"
    "Noto Sans CJK KR"
  ];
  fonts.fontconfig.defaultFonts.serif = [
    "NotoSerif Nerd Font"
    "Noto Serif CJK SC"
    "Noto Serif CJK TC"
    "Noto Serif CJK JP"
    "Noto Serif CJK KR"
  ];
  fonts.fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];

}
