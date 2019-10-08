#! /bin/sh

say () {
    echo "$*" >&2
}

export default_apt_packages="net-tools m4 pkg-config libhidapi-dev libev-dev libgmp-dev build-essential jq rlwrap"

full_tezos () {
    local branch="$1"
    local config="$2"
    local extra_opam_packages="$3"
    local extra_apt_packages="$4"
    say "Tezos-full+4.07 @$branch configuration"
    export apt_packages="$default_apt_packages $extra_apt_packages"
    export opam_packages="dune "
    export ocaml_version="4.07"
    export paths="./$config"
    export post=$(mktemp)
    local ipaddr_version="4.0.0"
    if [ "branch" = "mainnet" ] ; then
        ipaddr_version="3.1.0"
    fi
    cat > $post <<EOF
RUN opam pin add -n ocp-indent 1.6.1
RUN opam pin add -n ipaddr $ipaddr_version
RUN git clone https://gitlab.com/tezos/tezos.git -b $branch
WORKDIR tezos
EOF
    case "$branch" in
        "mainnet-staging" | "mainnet" )
            cat >> $post <<EOF
RUN opam config exec -- opam pin -n add dune 1.10.0
RUN opam config exec -- opam pin -n add zarith 1.7
EOF
            ;;
    esac
    cat >> $post <<EOF
ENV OPAMJOBS 2
RUN opam config exec -- bash -c 'opam install --ignore-constraints-on=dune $extra_opam_packages num base fmt odoc ocamlformat.0.10 \$(find src vendors -name "*.opam" -print)'
WORKDIR ..
RUN git clone https://gitlab.com/tezos/flextesa.git -b mainnet-compatible
RUN opam config exec -- opam pin -n add flextesa flextesa/src/lib/
RUN opam config exec -- opam install flextesa --ignore-constraints-on=dune
EOF
}

export s_opam_packages="parsexp num js_of_ocaml dune base alcotest fmt ppx_show odoc ocamlformat.0.10  ppx_deriving gen_js_api js_of_ocaml-ppx"
export s_apt_packages="parallel nodejs"
configure () {
    case "$1" in
        "S-408" )
            say "Default+4.08 configuration"
            export config="$config"
            export apt_packages="$default_apt_packages"
            export opam_packages="$s_opam_packages"
            export ocaml_version="4.08"
            export paths="./$config"
            ;;
        "T-407" )
            full_tezos "master" "$config" ;;
        "T-407-mainnet" )
            full_tezos "mainnet" "$config" ;;
        "ST-407-mainnet" )
            full_tezos "mainnet-staging" "$config" "$s_opam_packages" "$s_apt_packages" ;;
        "ST-407-master" )
            full_tezos "master" "$config" "$s_opam_packages" "$s_apt_packages" ;;
        "default" | "S-407" | * )
            say "Default configuration"
            export config="S-407"
            export apt_packages="$default_apt_packages $s_apt_packages"
            export opam_packages="$s_opam_packages"
            export ocaml_version="4.07"
            export paths="./$config ."
            ;;
    esac
}

update () {
    configure "$config"
    for path in $paths ; do
        mkdir -p $path
        say "Writing $path/Dockerfile"
        cat > $path/Dockerfile <<EOF
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
        if [ "$post" != "" ]; then
            cat "$post" >> $path/Dockerfile
        fi
        echo "WORKDIR /home/opam" >> $path/Dockerfile
    done
}

build () {
    dir="$1"
    if [ "$1" = "" ] ; then dir="." ; fi
    docker build -t soteredi-test "$dir"
}

all () {
    for config in S-407 S-408 T-407 T-407-mainnet ST-407-mainnet ST-407-master ; do
        export config
        update
    done
}

usage () {
    cat <<EOF
usage: [config=...] $0 {all,update,build,usage}
EOF
}

{
    if [ "$1" = "" ] ; then
        usage
    else
        "$@"
    fi
}

