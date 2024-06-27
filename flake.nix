{
  description = "A very basic flake";

  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
  };

  outputs = { nixpkgs-lib, nix-colors, ... }: {
    lib = (import ./lib.nix) {
      lib = nixpkgs-lib.lib;
      inherit nix-colors;
    };
  };
}
