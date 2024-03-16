{

  description = "sunn4room nixos config";

  inputs = {
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs?ref=nixos-23.11";
  };

  outputs = { self, nixpkgs, ... } @ inputs: {

    nixosConfigurations = {
      vbox = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        modules = [
          ./vbox/configuration.nix
        ];
      };
    };

  };

}
