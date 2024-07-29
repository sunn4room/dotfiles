{ config, lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    vscode
    shellcheck-minimal
    yarn
    pnpm
    bash-language-server
    typescript-language-server
    vue-language-server
    lua-language-server
  ];

}

