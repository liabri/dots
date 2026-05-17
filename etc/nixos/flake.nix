{
  description = "multi-channel";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    awww.url = "git+https://codeberg.org/LGFae/awww";
    pluto.url = "git+file:///home/liabri/loghob";
  };

  outputs = {self, ...}@sources: {
    nixosConfigurations = {
      venus = sources.nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit sources; };
        modules = [ ./hosts/venus/configuration.nix ];
      };

      mercury = sources.nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit sources; };
        modules = [ ./hosts/mercury/configuration.nix ];
      };
    };
  };
}
