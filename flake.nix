{

  description = "sunn4room nixos config";

  inputs = {
    nixpkgs.url = "https://github.moeyy.xyz/https://github.com/NixOS/nixpkgs/archive/89c49874fb15f4124bf71ca5f42a04f2ee5825fd.zip";
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
