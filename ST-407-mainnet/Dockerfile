# Generated for config: 'ST-407-mainnet'
FROM ocaml/opam2:4.07
RUN sudo apt-get update -qq
RUN sudo apt-get upgrade -y
RUN sudo apt-get install -y m4 pkg-config libhidapi-dev libev-dev libgmp-dev build-essential jq rlwrap
ENV OPAMYES 1
RUN opam config exec -- opam remote add mothership https://github.com/ocaml/opam-repository.git
RUN opam config exec -- opam update
RUN opam config exec -- opam upgrade
RUN opam config exec -- opam install dune 
RUN opam pin add -n ocp-indent 1.6.1
RUN opam pin add -n ipaddr 3.1.0
RUN git clone https://gitlab.com/tezos/tezos.git -b mainnet
WORKDIR tezos
RUN opam config exec -- opam pin -n dune 1.10.0
RUN opam config exec -- bash -c 'opam install --ignore-constraints-on=dune parsexp num js_of_ocaml dune base alcotest fmt ppx_show odoc ocamlformat.0.10 num base fmt odoc ocamlformat.0.10 $(find src vendors -name "*.opam" -print)'
WORKDIR /home/opam