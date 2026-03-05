{
  description = "flake for laptop";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    agenix.url = "github:ryantm/agenix";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # PATCHES

    # update early to kernel 6.19.6
    nixpkgs-patch-kernel-bump-6_19_6 = {
      url = "https://github.com/NixOS/nixpkgs/pull/496567.patch";
      flake = false;
    };
  };

  outputs = { self, nixpkgs-patcher, nixpkgs, home-manager, impermanence, agenix, lanzaboote, ... }@inputs: {
    nixosConfigurations = {
      laptop = nixpkgs-patcher.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          impermanence.nixosModules.impermanence
          lanzaboote.nixosModules.lanzaboote
          agenix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.viv = {
              imports = [ ./home.nix agenix.homeManagerModules.default ];
            };
          }
          {
            environment.systemPackages = [
              agenix.packages.x86_64-linux.default
            ];
          }
        ];
        specialArgs = inputs;
      };
    };
  };
}
