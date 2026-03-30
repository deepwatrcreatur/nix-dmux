{
  description = "Nix flake for the dmux CLI tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use your preferred Nixpkgs branch
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = self.packages.${system}.dmux;
          dmux = pkgs.callPackage ./pkgs { };
        }
      );

      overlays.default = final: prev: {
        dmux = self.packages.${prev.system}.dmux;
      };
    };
}
