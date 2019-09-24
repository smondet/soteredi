# Generated for config: 'S-408'
FROM ocaml/opam2:4.08
RUN sudo apt-get update -qq
RUN sudo apt-get upgrade -y
RUN sudo apt-get install -y net-tools m4 pkg-config libhidapi-dev libev-dev libgmp-dev build-essential jq rlwrap
ENV OPAMYES 1
RUN opam config exec -- opam remote add mothership https://github.com/ocaml/opam-repository.git
RUN opam config exec -- opam update
RUN opam config exec -- opam upgrade
RUN opam config exec -- opam install parsexp num js_of_ocaml dune base alcotest fmt ppx_show odoc ocamlformat.0.10  ppx_deriving gen_js_api js_of_ocaml-ppx
WORKDIR /home/opam
