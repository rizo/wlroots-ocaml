EXAMPLES := simple
EXAMPLES := $(patsubst %,examples/%.exe,$(EXAMPLES))

default:
	dune build @install

examples:
	dune build @examples

clean:
	rm -rf _build

docker-build:
	docker build -t wlroots-ocaml .

docker-shell:
	docker run -it -v "$$PWD:/app" wlroots-ocaml nix-shell -A shell

.PHONY: default clean examples docker-build docker-shell
