{
  description = "VerilogA compact model development flake.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        let
          vampyre = pkgs.callPackage nix/vampyre.nix { };
          pyenv = pkgs.python3.withPackages (ps: [
            ps.matplotlib
            ps.numpy
            ps.pandas
            ps.pandas-stubs
            ps.schemdraw
            ps.scipy
            ps.seaborn
          ]);
        in
        {
          packages = {
            inherit vampyre;
          };
          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.openvaf
              pkgs.vacask
              vampyre
              pyenv
              pkgs.xschem
            ];
          };
        };
    };
}
