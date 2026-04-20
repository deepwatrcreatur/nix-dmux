{ pkgs, lib }:

pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "dmux";
  version = "5.7.0";

  src = pkgs.fetchFromGitHub {
    owner = "standardagents";
    repo = "dmux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Vm/MKQSjKTxN1oNSzp2C54JUJJRuh+cS/w6w64E3QyE=";
  };

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-Kd50v58VLHVb4h4TZqtNGMRb+xuPmbsFSHHGpm0QPOQ=";
  };

  nativeBuildInputs = [
    pkgs.nodejs
    pkgs.pnpmConfigHook
    pkgs.pnpm
    pkgs.gnused
  ];

  dontNpmBuild = true;

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/${finalAttrs.pname}

    # Copy the main JavaScript source, its dependencies, and workspace packages
    cp -r ./dist $out/lib/${finalAttrs.pname}
    cp -r ./node_modules $out/lib/${finalAttrs.pname}/node_modules
    cp -r ./frontend $out/lib/${finalAttrs.pname}/frontend
    cp -r ./docs $out/lib/${finalAttrs.pname}/docs
    cp ./package.json $out/lib/${finalAttrs.pname}/package.json

    sed -i "s|\.\/dist\/index\.js|$out/lib/${finalAttrs.pname}/dist/index.js|" ./dmux
    sed -i "s|\.\.\/dist\/index\.js|$out/lib/${finalAttrs.pname}/dist/index.js|" ./dmux

    cp ./dmux $out/bin/dmux
    chmod +x $out/bin/dmux
  '';

  meta = {
    description = "A development agent multiplexer for git";
    homepage = "https://github.com/standardagents/dmux";
    license = pkgs.lib.licenses.mit;
    mainProgram = "dmux";
  };
})
