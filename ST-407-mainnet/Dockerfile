# Generated for config: 'ST-407-mainnet'
FROM ocaml/opam2:4.07
RUN sudo apt-get update -qq
RUN sudo apt-get upgrade -y
RUN sudo apt-get install -y net-tools m4 pkg-config libhidapi-dev libev-dev libgmp-dev build-essential jq rlwrap parallel nodejs
ENV OPAMYES 1
RUN opam config exec -- opam remote add mothership https://github.com/ocaml/opam-repository.git
RUN opam config exec -- opam update
RUN opam config exec -- opam upgrade
RUN opam config exec -- opam install dune 
RUN opam pin add -n ocp-indent 1.6.1
RUN opam pin add -n ipaddr 4.0.0
RUN git clone https://gitlab.com/tezos/tezos.git -b mainnet-staging
WORKDIR tezos
RUN opam config exec -- opam pin -n add dune 1.10.0
RUN opam config exec -- opam pin -n add zarith 1.7
ENV OPAMJOBS 2
RUN opam config exec -- bash -c 'opam install --ignore-constraints-on=dune parsexp num js_of_ocaml dune base alcotest fmt ppx_show odoc ocamlformat.0.10  ppx_deriving gen_js_api js_of_ocaml-ppx num base fmt odoc ocamlformat.0.10 $(find src vendors -name "*.opam" -print)'
WORKDIR ..
WORKDIR /home/opam
