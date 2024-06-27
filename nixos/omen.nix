{ config, lib, pkgs, ... }: {

  imports = [
    ./module/base.nix
    ./module/desktop.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  fileSystems."/".device = "/dev/disk/by-uuid/974b0c44-a344-44ad-8500-d7f613e4bcfb";
  fileSystems."/".fsType = "ext4";
  fileSystems."/boot".device = "/dev/disk/by-uuid/CD34-7B8E";
  fileSystems."/boot".fsType = "vfat";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "omen";
  networking.wireless.iwd.enable = true;

  services.libinput.enable = true;

}

