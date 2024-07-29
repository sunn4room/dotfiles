{

  description = "sunn4room nixos config";

  inputs = {
    nixpkgs.url = "https://github.moeyy.xyz/https://github.com/NixOS/nixpkgs/archive/f6d4f4f0550e3574dc9c95a0be83e5e94e3c1837.zip";
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
