{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    vscode
    shellcheck-minimal
  ];

}

