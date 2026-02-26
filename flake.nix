{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

  };

    outputs = { self, nixpkgs, ... }@inputs:
             let
               system = "x86_64-linux";

               pkgs = import nixpkgs {
                 inherit system;
                 config.allowUnfree = true;
               };

             in
               {
                 nixosConfigurations.patchovision = nixpkgs.lib.nixosSystem {
                   inherit system;
                   specialArgs = { inherit inputs; };
                   modules = [
                     ./configuration.nix
                   ];
                 };

               };
}
