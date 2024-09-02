{

  description = "sunn4room nixos config";

  inputs = {
    nixpkgs.url = "https://github.moeyy.xyz/https://github.com/NixOS/nixpkgs/archive/e3f44724538b5e727162c76e841d175d1ff838ea.zip";
    nixpkgs-unstable.url = "https://github.moeyy.xyz/https://github.com/NixOS/nixpkgs/archive/075e1905868bd6528e1e82a564081356fc8964fe.zip";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      omen = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/omen.nix];
      };
      vbox = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/vbox.nix];
      };
      vbox-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./nixos/vbox-desktop.nix];
      };
    };
  };
}
