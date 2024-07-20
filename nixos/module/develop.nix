{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    vscode
    shellcheck-minimal
    nodePackages.yarn
    nodePackages.bash-language-server
    lua-language-server
  ];

}

