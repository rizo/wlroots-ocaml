{ pkgs ? import <nixpkgs> { } }:

let
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_14;
  onix = import (builtins.fetchGit {
    url = "https://github.com/odis-labs/onix.git";
    rev = "ec7e0b480e88f5f19b0dc762aef16b249613d8b6";
  }) { inherit pkgs ocamlPackages; };

  waylandPkgs = let
    src = builtins.fetchGit {
      url = "https://github.com/nix-community/nixpkgs-wayland.git";
      rev = "f0e3a16ee80be6cb0e3f0251a653a59602e5e052";
    };
  in import "${src}/packages.nix";
in rec {
  scope = onix.build {
    lockFile = ./onix-lock.nix;
    withTest = true;
    withTools = true;
    overrides = self: super: {
      wlroots = super.wlroots.overrideAttrs (selfAttrs: superAttrs: {
        buildInputs = (superAttrs.buildInputs or [ ])
          ++ [ waylandPkgs.wlroots pkgs.udev pkgs.pixman ];
      });
      ctypes = super.ctypes.overrideAttrs (selfAttrs: superAttrs: {
        postInstall = ''
          mkdir -p  "$out/lib/ocaml/4.14.0/site-lib/stublibs"
          mv \
            "$out/lib/ocaml/4.14.0/site-lib/ctypes/dllctypes-foreign-base_stubs.so" \
            "$out/lib/ocaml/4.14.0/site-lib/ctypes/dllctypes-foreign-threaded_stubs.so" \
            "$out/lib/ocaml/4.14.0/site-lib/ctypes/dllctypes_stubs.so" \
            "$out/lib/ocaml/4.14.0/site-lib/stublibs"
        '';
      });
    };
  };

  lock = onix.lock {
    repoUrl =
      "https://github.com/ocaml/opam-repository.git#ae4cd72204df46de6705376d06268c351a8baab6";
    opamFiles = [ "./wlroots.opam" "./vendor/ocaml-xkbcommon/xkbcommon.opam" ];
    resolutions = { "ocaml-system" = "4.14.0"; };
    withTest = true;
    withTools = true;
  };

  shell = pkgs.mkShell {
    inputsFrom = [ scope.wlroots ];
    buildInputs = [ scope.tgls ];
  };
}
