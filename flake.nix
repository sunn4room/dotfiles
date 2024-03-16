{

  description = "sunn4room nixos config";

  inputs = {
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs?ref=nixos-23.11";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      vbox = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs output;};
        modules = [./nixos/vbox.nix];
      };
    };
  };
}
