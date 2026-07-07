{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  rustfmt,
  pkg-config,
  llvmPackages_21,
  python3,
}:
let
  llvm21BuildRustPackage = rustPlatform.buildRustPackage.override {
    stdenv = llvmPackages_21.stdenv;
  };
in
llvm21BuildRustPackage rec {
  pname = "openvaf";
  version = "23.5.0-unstable-2026-06-10";

  src = fetchFromGitHub {
    owner = "arpadbuermen";
    repo = "OpenVAF";
    rev = "2e066436d985b05cf8e6563e936daf9ab875775a";
    hash = "sha256-AXtp8qaDq/MRYz2TYXRwT3kS+8EnKyakD3lQwdv3K34=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-PchAbZN2a3mUMt3UUt7QiihoWSn8xBzg7w/v/7LWv2Q=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    rustfmt
    pkg-config
    llvmPackages_21.llvm
    llvmPackages_21.bintools
    llvmPackages_21.clang
    python3
  ];

  buildInputs = [
    llvmPackages_21.libclang
  ];

  hardeningDisable = [
    "pic"
    "zerocallusedregs"
  ];

  # Fails at openvaf/test_data which is not pulled in as it is not GPL-compatible
  cargoTestFlags = [ "--lib" ];

  env.LLVM_SYS_211_PREFIX = "${llvmPackages_21.llvm.dev}";

  cargoBuildType = "release";
  cargoBuildFlags = [
    "--bin"
    "openvaf-r"
  ];
  buildFeatures = [ "llvm21" ];

  meta = {
    description = "Verilog-A compiler based on LLVM";
    homepage = "https://github.com/arpadbuermen/OpenVAF";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fehlings
    ];
    platforms = lib.platforms.unix;
    mainProgram = "openvaf-r";
  };
}
