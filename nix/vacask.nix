{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  bison,
  flex,
  python3,
  libgcc,
  boost188,
  suitesparse,
  tomlplusplus,
  openvaf,
}:

stdenv.mkDerivation {
  pname = "vacask";
  version = "0.3.3";
  src = fetchgit {
    url = "https://codeberg.org/arpadbuermen/VACASK.git";
    rev = "8729bbf12145850c5697243d6c047b240d3a6e92";
    hash = "sha256-eU3SuJPqxqc8QO5k4Jb/9zc8V2JQ1VP1bPEoJ6KCi/c=";
  };
  nativeBuildInputs = [
    cmake
    ninja
    bison
    flex
    python3
  ];
  buildInputs = [
    libgcc
    boost188
    suitesparse
    tomlplusplus
    openvaf
  ];
  cmakeFlags = [
    "-G Ninja"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOPENVAF_DIR=${openvaf}/bin"
  ];

  # Nix uses the include/ prefix for suitesparse, but upstream assumes
  # the include/suitesparse/ prefix, as in the debian package
  # Accordingly, we link the headers to a debian-like prefix
  preBuild = ''
    mkdir -p $TMPDIR/include/suitesparse
    ln -s ${suitesparse.dev}/include/*.h $TMPDIR/include/suitesparse/
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$TMPDIR/include"
  '';

  # Upstream has hardcoded static linking. Nix's boost does not support it.
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "set(Boost_USE_STATIC_LIBS ON)" ""
  '';

  meta = {
    description = "Verilog-A Circuit Analysis Kernel";
    homepage = "https://codeberg.org/arpadbuermen/VACASK";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      fehlings
    ];
    platforms = lib.platforms.unix;
    mainProgram = "vacask";
  };
}
