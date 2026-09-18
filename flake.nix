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
          openvaf = pkgs.openvaf;
          vampyre = pkgs.callPackage nix/vampyre.nix { };
          vacask = pkgs.callPackage nix/vacask.nix {
            inherit openvaf;
          };
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
            inherit openvaf vampyre vacask;
          };
          devShells.default = pkgs.mkShell {
            buildInputs = [
              openvaf
              vacask
              vampyre
              pyenv
              pkgs.xschem
            ];
          };
        };
    };
}
