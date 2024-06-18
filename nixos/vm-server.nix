{ config, lib, pkgs, ... }: {

  imports = [
    ./base.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "ohci_pci"
    "ehci_pci"
    "ahci"
    "sd_mod"
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/".device = "/dev/disk/by-label/root";
  fileSystems."/".fsType = "ext4";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  fileSystems."/boot".fsType = "vfat";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName = "vm-server";
  networking.interfaces.enp0s3.useDHCP = true;

  virtualisation.virtualbox.guest.enable = true;

}

