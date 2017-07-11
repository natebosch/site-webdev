#!/usr/bin/env bash

if [[ -z "$NGIO_ENV_DEFS" ]]; then
    export ANSI_YELLOW="\033[33;1m"
    export ANSI_RESET="\033[0m"
    echo -e "${ANSI_YELLOW}Setting environment variables from scripts/env-set.sh${ANSI_RESET} "

    export NGIO_ENV_DEFS=1

    : ${NGIO_REPO:=../angular.io}
    export NGIO_REPO
    : ${NG_REPO:=../angular}
    export NG_REPO
    : ${NGDOCEX:=examples/ng/doc}
    export NGDOCEX
    : ${ACX_REPO:=../angular_components}
    export ACX_REPO
    : ${CEU_REPO:=../code_excerpt_updater}
    export CEU_REPO

    # Git tag names
    export NG_RELEASE=3.1.0
    export NG_TEST_RELEASE=1.0.0-beta+3
    export ACX_RELEASE=v0.5.2

    if [ ! $(type -t travis_fold) ]; then
        # In case this is being run locally. Turn travis_fold into a noop.
        travis_fold () { true; }
        # Alternative definition:
        # travis_fold () { echo -en "travis_fold:${1}:${2}"; }
    fi
    export -f travis_fold

    case "$(uname -a)" in
        Darwin\ *) _OS_NAME=macos ;;
        Linux\ *) _OS_NAME=linux ;;
        *) _OS_NAME=linux ;;
    esac
    export _OS_NAME

    : ${TMP:=$HOME/tmp}
    : ${PKG:=$TMP/pkg}
    export TMP
    export PKG

    if [[ -z "$(type -t dart)" && ! $PATH =~ */dart-sdk/* ]]; then
        export DART_SDK="$PKG/dart-sdk"
        # Updating PATH to include access to Dart bin.
        export PATH="$DART_SDK/bin:$PATH"
        export PATH="$HOME/.pub-cache/bin:$PATH"
    fi

    if [[ -z "$(type -t content_shell)" ]]; then
        export PATH="$PKG/content_shell:$PATH"
    fi
fi
