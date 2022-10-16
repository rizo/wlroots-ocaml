{ pkgs ? import <nixpkgs> {} }:
rec {
  version = "0.0.5";
  repo = builtins.fetchGit {
    url = "https://github.com/ocaml/opam-repository.git";
    rev = "ae4cd72204df46de6705376d06268c351a8baab6";
  };
  scope = rec {
    base = {
      name = "base";
      version = "v0.15.1";
      src = pkgs.fetchurl {
        url = "https://github.com/janestreet/base/archive/refs/tags/v0.15.1.tar.gz";
        sha256 = "755e303171ea267e3ba5af7aa8ea27537f3394d97c77d340b10f806d6ef61a14";
      };
      opam = "${repo}/packages/base/base.v0.15.1/opam";
      depends = [ dune dune-configurator ocaml sexplib0 ];
      buildDepends = [ dune dune-configurator ocaml ];
    };
    base-bytes = {
      name = "base-bytes";
      version = "base";
      opam = "${repo}/packages/base-bytes/base-bytes.base/opam";
      depends = [ ocaml ocamlfind ];
      buildDepends = [ ocaml ocamlfind ];
    };
    base-threads = {
      name = "base-threads";
      version = "base";
      opam = "${repo}/packages/base-threads/base-threads.base/opam";
    };
    base-unix = {
      name = "base-unix";
      version = "base";
      opam = "${repo}/packages/base-unix/base-unix.base/opam";
    };
    conf-libffi = {
      name = "conf-libffi";
      version = "2.0.0";
      opam = "${repo}/packages/conf-libffi/conf-libffi.2.0.0/opam";
      buildDepends = [ conf-pkg-config ];
      depexts = [ pkgs.libffi ];
    };
    conf-pkg-config = {
      name = "conf-pkg-config";
      version = "2";
      opam = "${repo}/packages/conf-pkg-config/conf-pkg-config.2/opam";
      depexts = [ pkgs.pkgconfig ];
    };
    conf-xkbcommon = {
      name = "conf-xkbcommon";
      version = "1";
      opam = "${repo}/packages/conf-xkbcommon/conf-xkbcommon.1/opam";
      buildDepends = [ conf-pkg-config ];
      depexts = [ (pkgs.libxkbcommon or null) (pkgs.libxkbcommon-dev or null)
                  (pkgs.libxkbcommon-devel or null) ];
    };
    csexp = {
      name = "csexp";
      version = "1.5.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml-dune/csexp/releases/download/1.5.1/csexp-1.5.1.tbz";
        sha256 = "d605e4065fa90a58800440ef2f33a2d931398bf2c22061a8acb7df845c0aac02";
      };
      opam = "${repo}/packages/csexp/csexp.1.5.1/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    ctypes = {
      name = "ctypes";
      version = "0.17.1";
      src = pkgs.fetchurl {
        url = "https://github.com/yallop/ocaml-ctypes/archive/0.17.1.tar.gz";
        sha256 = "1sd74bcsln51bnz11c82v6h6fv23dczfyfqqvv9rxa9wp4p3qrs1";
      };
      opam = "${repo}/packages/ctypes/ctypes.0.17.1/opam";
      depends = [ ctypes-foreign integers ocaml ];
      buildDepends = [ conf-pkg-config ocaml ocamlfind ];
    };
    ctypes-foreign = {
      name = "ctypes-foreign";
      version = "0.18.0";
      opam = "${repo}/packages/ctypes-foreign/ctypes-foreign.0.18.0/opam";
      depends = [ conf-libffi ];
      buildDepends = [ conf-pkg-config ];
    };
    dune = {
      name = "dune";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/dune/dune.3.4.1/opam";
      depends = [ base-threads base-unix ocaml ];
      buildDepends = [ ocaml ];
    };
    dune-configurator = {
      name = "dune-configurator";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/dune-configurator/dune-configurator.3.4.1/opam";
      depends = [ base-unix csexp dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    integers = {
      name = "integers";
      version = "0.7.0";
      src = pkgs.fetchurl {
        url = "https://github.com/yallop/ocaml-integers/archive/0.7.0.tar.gz";
        sha256 = "11f67v9bijhkbnia7vrdp6sfpyw92kp39kn4p1p2860qkbx1gdcb";
      };
      opam = "${repo}/packages/integers/integers.0.7.0/opam";
      depends = [ dune ocaml stdlib-shims ];
      buildDepends = [ dune ocaml ];
    };
    mtime = {
      name = "mtime";
      version = "1.4.0";
      src = pkgs.fetchurl {
        url = "https://erratique.ch/software/mtime/releases/mtime-1.4.0.tbz";
        sha512 = "0492fa5f5187b909fe2b0550363c7dcb8cffef963d51072272ef3d876b51e1ddf8de4c4e221cffb0144658fccf6a0dc584a5c8094a4b2208156e43bad5b269d4";
      };
      opam = "${repo}/packages/mtime/mtime.1.4.0/opam";
      depends = [ ocaml ];
      buildDepends = [ ocaml ocamlbuild ocamlfind topkg ];
    };
    ocaml = {
      name = "ocaml";
      version = "4.14.0";
      opam = "${repo}/packages/ocaml/ocaml.4.14.0/opam";
      depends = [ ocaml-config ocaml-system ];
    };
    ocaml-config = {
      name = "ocaml-config";
      version = "2";
      opam = "${repo}/packages/ocaml-config/ocaml-config.2/opam";
      depends = [ ocaml-system ];
    };
    ocaml-system = {
      name = "ocaml-system";
      version = "4.14.0";
      opam = "${repo}/packages/ocaml-system/ocaml-system.4.14.0/opam";
      depexts = [ pkgs.ocaml-ng.ocamlPackages_4_14.ocaml ];
    };
    ocamlbuild = {
      name = "ocamlbuild";
      version = "0.14.2";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/ocamlbuild/archive/refs/tags/0.14.2.tar.gz";
        sha512 = "f568bf10431a1f701e8bd7554dc662400a0d978411038bbad93d44dceab02874490a8a5886a9b44e017347e7949997f13f5c3752f74e1eb5e273d2beb19a75fd";
      };
      opam = "${repo}/packages/ocamlbuild/ocamlbuild.0.14.2/opam";
      depends = [ ocaml ];
      buildDepends = [ ocaml ];
    };
    ocamlfind = {
      name = "ocamlfind";
      version = "1.9.5";
      src = pkgs.fetchurl {
        url = "http://download.camlcity.org/download/findlib-1.9.5.tar.gz";
        sha512 = "03514c618a16b02889db997c6c4789b3436b3ad7d974348d2c6dea53eb78898ab285ce5f10297c074bab4fd2c82931a8b7c5c113b994447a44abb30fca74c715";
      };
      opam = "${repo}/packages/ocamlfind/ocamlfind.1.9.5/opam";
      depends = [ ocaml ];
      buildDepends = [ ocaml ];
    };
    result = {
      name = "result";
      version = "1.5";
      src = pkgs.fetchurl {
        url = "https://github.com/janestreet/result/releases/download/1.5/result-1.5.tbz";
        sha256 = "0cpfp35fdwnv3p30a06wd0py3805qxmq3jmcynjc3x2qhlimwfkw";
      };
      opam = "${repo}/packages/result/result.1.5/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    sexplib0 = {
      name = "sexplib0";
      version = "v0.15.1";
      src = pkgs.fetchurl {
        url = "https://github.com/janestreet/sexplib0/archive/refs/tags/v0.15.1.tar.gz";
        sha256 = "1cv78931di97av82khqwmx5s51mrn9d2b82z0si88gxwndz83kg8";
      };
      opam = "${repo}/packages/sexplib0/sexplib0.v0.15.1/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    stdio = {
      name = "stdio";
      version = "v0.15.0";
      src = pkgs.fetchurl {
        url = "https://ocaml.janestreet.com/ocaml-core/v0.15/files/stdio-v0.15.0.tar.gz";
        sha256 = "c37292921dc6a88425f773eba6bdbeac1dedacd1f55917fa4bcd9c4b25795e4b";
      };
      opam = "${repo}/packages/stdio/stdio.v0.15.0/opam";
      depends = [ base dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    stdlib-shims = {
      name = "stdlib-shims";
      version = "0.3.0";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/stdlib-shims/releases/download/0.3.0/stdlib-shims-0.3.0.tbz";
        sha256 = "babf72d3917b86f707885f0c5528e36c63fccb698f4b46cf2bab5c7ccdd6d84a";
      };
      opam = "${repo}/packages/stdlib-shims/stdlib-shims.0.3.0/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    topkg = {
      name = "topkg";
      version = "1.0.5";
      src = pkgs.fetchurl {
        url = "https://erratique.ch/software/topkg/releases/topkg-1.0.5.tbz";
        sha512 = "9450e9139209aacd8ddb4ba18e4225770837e526a52a56d94fd5c9c4c9941e83e0e7102e2292b440104f4c338fabab47cdd6bb51d69b41cc92cc7a551e6fefab";
      };
      opam = "${repo}/packages/topkg/topkg.1.0.5/opam";
      depends = [ ocaml ocamlbuild ];
      buildDepends = [ ocaml ocamlbuild ocamlfind ];
    };
    unix-errno = {
      name = "unix-errno";
      version = "0.5.2";
      src = pkgs.fetchurl {
        url = "https://github.com/dsheets/ocaml-unix-errno/archive/0.5.2.tar.gz";
        sha256 = "0gx8nr33ycqlvahi0r91a79xa3k5an1c4l3qza2xa1vnmndbjp7q";
      };
      opam = "${repo}/packages/unix-errno/unix-errno.0.5.2/opam";
      depends = [ base-bytes base-unix ctypes ocaml result ];
      buildDepends = [ ocaml ocamlbuild ocamlfind ];
    };
    unix-time = {
      name = "unix-time";
      version = "0.1.0";
      src = pkgs.fetchurl {
        url = "https://github.com/dsheets/ocaml-unix-time/archive/0.1.0.tar.gz";
        sha256 = "1j98p7h5p5560pfhn3kn8y7vkx3mp5si3g2jvd0x7mm9jlfg3kvi";
      };
      opam = "${repo}/packages/unix-time/unix-time.0.1.0/opam";
      depends = [ base-unix ctypes ocaml unix-errno ];
      buildDepends = [ ocaml ocamlbuild ocamlfind ];
    };
    wlroots = {
      name = "wlroots";
      version = "root";
      src = pkgs.nix-gitignore.gitignoreSource [] ./.;
      opam = "${wlroots.src}/wlroots.opam";
      depends = [ ctypes ctypes-foreign dune mtime ocaml unix-time xkbcommon ];
      buildDepends = [ base dune ocaml stdio ];
    };
    xkbcommon = {
      name = "xkbcommon";
      version = "root";
      src = pkgs.nix-gitignore.gitignoreSource [] ./vendor/ocaml-xkbcommon;
      opam = "${xkbcommon.src}/xkbcommon.opam";
      depends = [ conf-xkbcommon ctypes ctypes-foreign dune ocaml ];
      buildDepends = [ base dune ocaml stdio ];
    };
  };
}
