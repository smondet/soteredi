#! /bin/sh

say () {
    echo "$*" >&2
}

configure () {
    case "$1" in
        "default" | "S-407" | * )
            say "Default configuration"
            export config="S-407"
            export apt_packages="m4 pkg-config libgmp-dev build-essential"
            export opam_packages="parsexp num js_of_ocaml dune base alcotest fmt ppx_show odoc ocamlformat.0.10"
            export ocaml_version="4.07"
            ;;
    esac
}

update () {
    configure "$config"
    cat > Dockerfile <<EOF
# Generated for config: '$config'
FROM ocaml/opam2:$ocaml_version
RUN sudo apt-get update -qq
RUN sudo apt-get upgrade -y
RUN sudo apt-get install -y $apt_packages
ENV OPAMYES 1
RUN opam config exec -- opam remote add mothership https://github.com/ocaml/opam-repository.git
RUN opam config exec -- opam update
RUN opam config exec -- opam upgrade
RUN opam config exec -- opam install $opam_packages
EOF
}

build () {
    docker build -t soteredi .
}

usage () {
    cat <<EOF
usage: [config=...] $0 {update,build,usage}
EOF
}

{
    if [ "$1" = "" ] ; then
        usage
    else
        "$@"
    fi
}

