{ pkgs ? import <nixpkgs> {} }:
rec {
  version = "0.0.5";
  repo = builtins.fetchGit {
    url = "https://github.com/ocaml/opam-repository.git";
    rev = "ae4cd72204df46de6705376d06268c351a8baab6";
  };
  scope = rec {
    astring = {
      name = "astring";
      version = "0.8.5";
      src = pkgs.fetchurl {
        url = "https://erratique.ch/software/astring/releases/astring-0.8.5.tbz";
        sha256 = "1ykhg9gd3iy7zsgyiy2p9b1wkpqg9irw5pvcqs3sphq71iir4ml6";
      };
      opam = "${repo}/packages/astring/astring.0.8.5/opam";
      depends = [ ocaml ];
      buildDepends = [ ocaml ocamlbuild ocamlfind topkg ];
    };
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
    base-bigarray = {
      name = "base-bigarray";
      version = "base";
      opam = "${repo}/packages/base-bigarray/base-bigarray.base/opam";
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
    camlp-streams = {
      name = "camlp-streams";
      version = "5.0.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/camlp-streams/archive/v5.0.1.tar.gz";
        sha512 = "2efa8dd4a636217c8d49bac1e4e7e5558fc2f45cfea66514140a59fd99dd08d61fb9f1e17804997ff648b71b13820a5d4a1eb70fed9d848aa2abd6e41f853c86";
      };
      opam = "${repo}/packages/camlp-streams/camlp-streams.5.0.1/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    chrome-trace = {
      name = "chrome-trace";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/chrome-trace/chrome-trace.3.4.1/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    cmdliner = {
      name = "cmdliner";
      version = "1.1.1";
      src = pkgs.fetchurl {
        url = "https://erratique.ch/software/cmdliner/releases/cmdliner-1.1.1.tbz";
        sha512 = "5478ad833da254b5587b3746e3a8493e66e867a081ac0f653a901cc8a7d944f66e4387592215ce25d939be76f281c4785702f54d4a74b1700bc8838a62255c9e";
      };
      opam = "${repo}/packages/cmdliner/cmdliner.1.1.1/opam";
      depends = [ ocaml ];
      buildDepends = [ ocaml ];
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
    cppo = {
      name = "cppo";
      version = "1.6.9";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml-community/cppo/archive/v1.6.9.tar.gz";
        sha512 = "26ff5a7b7f38c460661974b23ca190f0feae3a99f1974e0fd12ccf08745bd7d91b7bc168c70a5385b837bfff9530e0e4e41cf269f23dd8cf16ca658008244b44";
      };
      opam = "${repo}/packages/cppo/cppo.1.6.9/opam";
      depends = [ base-unix dune ocaml ];
      buildDepends = [ dune ocaml ];
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
    dune-build-info = {
      name = "dune-build-info";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/dune-build-info/dune-build-info.3.4.1/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
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
    dune-rpc = {
      name = "dune-rpc";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/dune-rpc/dune-rpc.3.4.1/opam";
      depends = [ csexp dune dyn ordering pp stdune xdg ];
      buildDepends = [ dune ];
    };
    dyn = {
      name = "dyn";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/dyn/dyn.3.4.1/opam";
      depends = [ dune ocaml ordering pp ];
      buildDepends = [ dune ocaml ];
    };
    either = {
      name = "either";
      version = "1.0.0";
      src = pkgs.fetchurl {
        url = "https://github.com/mirage/either/releases/download/1.0.0/either-1.0.0.tbz";
        sha256 = "bf674de3312dee7b7215f07df1e8a96eb3d679164b8a918cdd95b8d97e505884";
      };
      opam = "${repo}/packages/either/either.1.0.0/opam";
      depends = [ dune ];
      buildDepends = [ dune ];
    };
    fiber = {
      name = "fiber";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/fiber/fiber.3.4.1/opam";
      depends = [ dune dyn ocaml stdune ];
      buildDepends = [ dune ocaml ];
    };
    fix = {
      name = "fix";
      version = "20220121";
      src = pkgs.fetchurl {
        url = "https://gitlab.inria.fr/fpottier/fix/-/archive/20220121/archive.tar.gz";
        sha512 = "a851d8783c0c519c6e55359a5c471af433058872409c29a1a7bdfd0076813341ad2c0ebd1ce9e28bff4d4c729dfbc808c41c084fe12a42b45a2b5e391e77ccd2";
      };
      opam = "${repo}/packages/fix/fix.20220121/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    fpath = {
      name = "fpath";
      version = "0.7.3";
      src = pkgs.fetchurl {
        url = "https://erratique.ch/software/fpath/releases/fpath-0.7.3.tbz";
        sha256 = "03z7mj0sqdz465rc4drj1gr88l9q3nfs374yssvdjdyhjbqqzc0j";
      };
      opam = "${repo}/packages/fpath/fpath.0.7.3/opam";
      depends = [ astring ocaml ];
      buildDepends = [ ocaml ocamlbuild ocamlfind topkg ];
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
    menhir = {
      name = "menhir";
      version = "20220210";
      src = pkgs.fetchurl {
        url = "https://gitlab.inria.fr/fpottier/menhir/-/archive/20220210/archive.tar.gz";
        sha512 = "3063fec1d8b9fe092c8461b0689d426c7fe381a2bf3fd258dc42ceecca1719d32efbb8a18d94ada5555c38175ea352da3adbb239fdbcbcf52c3a5c85a4d9586f";
      };
      opam = "${repo}/packages/menhir/menhir.20220210/opam";
      depends = [ dune menhirLib menhirSdk ocaml ];
      buildDepends = [ dune ocaml ];
    };
    menhirLib = {
      name = "menhirLib";
      version = "20220210";
      src = pkgs.fetchurl {
        url = "https://gitlab.inria.fr/fpottier/menhir/-/archive/20220210/archive.tar.gz";
        sha512 = "3063fec1d8b9fe092c8461b0689d426c7fe381a2bf3fd258dc42ceecca1719d32efbb8a18d94ada5555c38175ea352da3adbb239fdbcbcf52c3a5c85a4d9586f";
      };
      opam = "${repo}/packages/menhirLib/menhirLib.20220210/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    menhirSdk = {
      name = "menhirSdk";
      version = "20220210";
      src = pkgs.fetchurl {
        url = "https://gitlab.inria.fr/fpottier/menhir/-/archive/20220210/archive.tar.gz";
        sha512 = "3063fec1d8b9fe092c8461b0689d426c7fe381a2bf3fd258dc42ceecca1719d32efbb8a18d94ada5555c38175ea352da3adbb239fdbcbcf52c3a5c85a4d9586f";
      };
      opam = "${repo}/packages/menhirSdk/menhirSdk.20220210/opam";
      depends = [ dune ocaml ];
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
    ocaml-lsp-server = {
      name = "ocaml-lsp-server";
      version = "1.13.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/ocaml-lsp/releases/download/1.13.1/lsp-1.13.1.tbz";
        sha256 = "e55f5bd88a5be2ff325fbc3b98eb7317d64de12b3f59d8c812e3ea2824fd0cfc";
      };
      opam = "${repo}/packages/ocaml-lsp-server/ocaml-lsp-server.1.13.1/opam";
      depends = [ chrome-trace csexp dune dune-build-info dune-rpc dyn fiber
                  ocaml ocamlformat-rpc-lib octavius omd ordering pp
                  ppx_yojson_conv_lib re spawn stdune uutf xdg yojson ];
      buildDepends = [ dune ocaml ];
    };
    ocaml-system = {
      name = "ocaml-system";
      version = "4.14.0";
      opam = "${repo}/packages/ocaml-system/ocaml-system.4.14.0/opam";
      depexts = [ pkgs.ocaml-ng.ocamlPackages_4_14.ocaml ];
    };
    ocaml-version = {
      name = "ocaml-version";
      version = "3.5.0";
      src = pkgs.fetchurl {
        url = "https://github.com/ocurrent/ocaml-version/releases/download/v3.5.0/ocaml-version-3.5.0.tbz";
        sha256 = "d63ca1c3970d6b14057f7176bfdae623e6c0176287c6a6e8b78cf50e2f7f635b";
      };
      opam = "${repo}/packages/ocaml-version/ocaml-version.3.5.0/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
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
    ocamlformat = {
      name = "ocamlformat";
      version = "0.24.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/0.24.1/ocamlformat-0.24.1.tbz";
        sha256 = "023425e9818f80ea50537b2371a4a766c149a9957d05807e88a004d2d5f441ce";
      };
      opam = "${repo}/packages/ocamlformat/ocamlformat.0.24.1/opam";
      depends = [ base cmdliner csexp dune dune-build-info either fix fpath
                  menhir menhirLib menhirSdk ocaml ocaml-version ocp-indent
                  odoc-parser re stdio uuseg uutf ];
      buildDepends = [ dune menhir ocaml ];
    };
    ocamlformat-rpc-lib = {
      name = "ocamlformat-rpc-lib";
      version = "0.24.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml-ppx/ocamlformat/releases/download/0.24.1/ocamlformat-0.24.1.tbz";
        sha256 = "023425e9818f80ea50537b2371a4a766c149a9957d05807e88a004d2d5f441ce";
      };
      opam = "${repo}/packages/ocamlformat-rpc-lib/ocamlformat-rpc-lib.0.24.1/opam";
      depends = [ csexp dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    ocp-indent = {
      name = "ocp-indent";
      version = "1.8.1";
      src = pkgs.fetchurl {
        url = "https://github.com/OCamlPro/ocp-indent/archive/1.8.1.tar.gz";
        sha512 = "565353de333dd44375366fff75e85a6256c3cd9ff52b3db79803141f975e77cda04dfe32f5e0f2d4c82c59be8f04e9c2bf4d066b113b2cdf267f4c3dcfa401da";
      };
      opam = "${repo}/packages/ocp-indent/ocp-indent.1.8.1/opam";
      depends = [ base-bytes cmdliner dune ocaml ocamlfind ];
      buildDepends = [ dune ocaml ocamlfind ];
    };
    octavius = {
      name = "octavius";
      version = "1.2.2";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml-doc/octavius/archive/v1.2.2.tar.gz";
        sha256 = "1bg0fcm7haqxvx5wx2cci0mbbq0gf1vw9fa4kkd6jsriw1611jga";
      };
      opam = "${repo}/packages/octavius/octavius.1.2.2/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    odoc-parser = {
      name = "odoc-parser";
      version = "2.0.0";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml-doc/odoc-parser/releases/download/2.0.0/odoc-parser-2.0.0.tbz";
        sha256 = "407919fbb0eb95761d6fc6ec6777628d94aa1907343bdca678b1880bafb33922";
      };
      opam = "${repo}/packages/odoc-parser/odoc-parser.2.0.0/opam";
      depends = [ astring camlp-streams dune ocaml result ];
      buildDepends = [ dune ocaml ];
    };
    omd = {
      name = "omd";
      version = "1.3.2";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/omd/releases/download/1.3.2/omd-1.3.2.tbz";
        sha256 = "6023e1642631f08f678eb5725820879ed7bb5a3ffee777cdedebc28c1f85fadb";
      };
      opam = "${repo}/packages/omd/omd.1.3.2/opam";
      depends = [ base-bigarray base-bytes dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    ordering = {
      name = "ordering";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/ordering/ordering.3.4.1/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    pp = {
      name = "pp";
      version = "1.1.2";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml-dune/pp/releases/download/1.1.2/pp-1.1.2.tbz";
        sha256 = "e4a4e98d96b1bb76950fcd6da4e938c86d989df4d7e48f02f7a44595f5af1d56";
      };
      opam = "${repo}/packages/pp/pp.1.1.2/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    ppx_yojson_conv_lib = {
      name = "ppx_yojson_conv_lib";
      version = "v0.15.0";
      src = pkgs.fetchurl {
        url = "https://ocaml.janestreet.com/ocaml-core/v0.15/files/ppx_yojson_conv_lib-v0.15.0.tar.gz";
        sha256 = "f9d2c5eff4566ec1f1f379b186ed22c8ddd6be0909a160bc5a9ac7abc6a6b684";
      };
      opam = "${repo}/packages/ppx_yojson_conv_lib/ppx_yojson_conv_lib.v0.15.0/opam";
      depends = [ dune ocaml yojson ];
      buildDepends = [ dune ocaml ];
    };
    re = {
      name = "re";
      version = "1.10.4";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/ocaml-re/releases/download/1.10.4/re-1.10.4.tbz";
        sha256 = "83eb3e4300aa9b1dc7820749010f4362ea83524742130524d78c20ce99ca747c";
      };
      opam = "${repo}/packages/re/re.1.10.4/opam";
      depends = [ dune ocaml seq ];
      buildDepends = [ dune ocaml ];
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
    seq = {
      name = "seq";
      version = "base";
      opam = "${repo}/packages/seq/seq.base/opam";
      depends = [ ocaml ];
      buildDepends = [ ocaml ];
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
    spawn = {
      name = "spawn";
      version = "v0.15.1";
      src = pkgs.fetchurl {
        url = "https://github.com/janestreet/spawn/archive/v0.15.1.tar.gz";
        sha256 = "9afdee314fab6c3fcd689ab6eb5608d6b78078e6dede3953a47debde06c19d50";
      };
      opam = "${repo}/packages/spawn/spawn.v0.15.1/opam";
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
    stdune = {
      name = "stdune";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/stdune/stdune.3.4.1/opam";
      depends = [ base-unix csexp dune dyn ocaml ordering pp ];
      buildDepends = [ dune ocaml ];
    };
    tgls = {
      name = "tgls";
      version = "0.8.6";
      src = pkgs.fetchurl {
        url = "https://erratique.ch/software/tgls/releases/tgls-0.8.6.tbz";
        sha512 = "837f030860a8c53d1dad5677240bb106fe4c44270a6615cdf90236fea50882420a303ac6df988b83ef92c1ae5fe6522e39dcb058ef4166422b7978dee4b5143b";
      };
      opam = "${repo}/packages/tgls/tgls.0.8.6/opam";
      depends = [ ctypes ctypes-foreign ocaml ];
      buildDepends = [ ocaml ocamlbuild ocamlfind topkg ];
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
    uucp = {
      name = "uucp";
      version = "15.0.0";
      src = pkgs.fetchurl {
        url = "https://erratique.ch/software/uucp/releases/uucp-15.0.0.tbz";
        sha512 = "ee4acff5666961766321e85e287fb9d5b8d50533319f22bf6f4eceb943242df2d0e0f4e775c4a140f68ca142837938eaa5926e22362215a3365ffe7f8768923b";
      };
      opam = "${repo}/packages/uucp/uucp.15.0.0/opam";
      depends = [ cmdliner ocaml uutf ];
      buildDepends = [ ocaml ocamlbuild ocamlfind topkg ];
    };
    uuseg = {
      name = "uuseg";
      version = "15.0.0";
      src = pkgs.fetchurl {
        url = "https://erratique.ch/software/uuseg/releases/uuseg-15.0.0.tbz";
        sha512 = "37ea83b582dd779a026cfae11f08f5d67ef79fce65a2cf03f2a9aabc7eb5de60c8e812524fa7531e4ff6e22a3b18228e3438a0143ce43be95f23237cc283576f";
      };
      opam = "${repo}/packages/uuseg/uuseg.15.0.0/opam";
      depends = [ cmdliner ocaml uucp uutf ];
      buildDepends = [ ocaml ocamlbuild ocamlfind topkg ];
    };
    uutf = {
      name = "uutf";
      version = "1.0.3";
      src = pkgs.fetchurl {
        url = "https://erratique.ch/software/uutf/releases/uutf-1.0.3.tbz";
        sha512 = "50cc4486021da46fb08156e9daec0d57b4ca469b07309c508d5a9a41e9dbcf1f32dec2ed7be027326544453dcaf9c2534919395fd826dc7768efc6cc4bfcc9f8";
      };
      opam = "${repo}/packages/uutf/uutf.1.0.3/opam";
      depends = [ cmdliner ocaml ];
      buildDepends = [ ocaml ocamlbuild ocamlfind topkg ];
    };
    wlroots = {
      name = "wlroots";
      version = "root";
      src = pkgs.nix-gitignore.gitignoreSource [] ./.;
      opam = "${wlroots.src}/wlroots.opam";
      depends = [ ctypes ctypes-foreign dune mtime ocaml unix-time xkbcommon ];
      buildDepends = [ base dune ocaml stdio ];
      testDepends = [ tgls ];
      toolsDepends = [ ocaml-lsp-server ocamlformat ];
      depexts = [ pkgs.wayland pkgs.wayland-protocols ];
    };
    xdg = {
      name = "xdg";
      version = "3.4.1";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml/dune/releases/download/3.4.1/dune-3.4.1.tbz";
        sha256 = "299fa33cffc108cc26ff59d5fc9d09f6cb0ab3ac280bf23a0114cfdc0b40c6c5";
      };
      opam = "${repo}/packages/xdg/xdg.3.4.1/opam";
      depends = [ dune ocaml ];
      buildDepends = [ dune ocaml ];
    };
    xkbcommon = {
      name = "xkbcommon";
      version = "root";
      src = pkgs.nix-gitignore.gitignoreSource [] ./vendor/ocaml-xkbcommon;
      opam = "${xkbcommon.src}/xkbcommon.opam";
      depends = [ conf-xkbcommon ctypes ctypes-foreign dune ocaml ];
      buildDepends = [ base dune ocaml stdio ];
    };
    yojson = {
      name = "yojson";
      version = "2.0.2";
      src = pkgs.fetchurl {
        url = "https://github.com/ocaml-community/yojson/releases/download/2.0.2/yojson-2.0.2.tbz";
        sha256 = "876bb6f38af73a84a29438a3da35e4857c60a14556a606525b148c6fdbe5461b";
      };
      opam = "${repo}/packages/yojson/yojson.2.0.2/opam";
      depends = [ dune ocaml seq ];
      buildDepends = [ cppo dune ocaml ];
    };
  };
}
