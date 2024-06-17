{ config, lib, pkgs, ... }: {

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  nixpkgs.hostPlatform = "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.interfaces.enp0s3.useDHCP = true;

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  # services.xserver.enable = true;

  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # services.xserver.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    wget
    tmux
    chezmoi
  ];

  services.openssh.enable = true;

  users.users.sunny = {
    initialPassword = "sunny";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "24.05";

}

