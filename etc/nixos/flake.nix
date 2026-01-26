{
  description = "multi-channel";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, awww }: {
    nixosConfigurations.liabri = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit awww; stable = nixpkgs-stable; };
      modules = [ ./configuration.nix ];
    };
  };
}
