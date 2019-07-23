# Generated for config: 'S-407'
FROM ocaml/opam2:4.07
RUN sudo apt-get update -qq
RUN sudo apt-get upgrade -y
RUN sudo apt-get install -y m4 pkg-config libgmp-dev build-essential
ENV OPAMYES 1
RUN opam config exec -- opam remote add mothership https://github.com/ocaml/opam-repository.git
RUN opam config exec -- opam update
RUN opam config exec -- opam upgrade
RUN opam config exec -- opam install parsexp num js_of_ocaml dune base alcotest fmt ppx_show odoc ocamlformat.0.10
