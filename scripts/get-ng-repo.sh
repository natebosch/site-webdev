#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

if [[ -e "$NG_REPO" ]]; then
  echo Angular repo is already present at: $NG_REPO
else
  travis_fold start get_repos_ng
  echo GETTING Angular from GitHub ...
  set -x
  git clone https://github.com/dart-lang/angular.git $NG_REPO
  # FIXME: temporary, until 3.2.0-alpha or later comes out: stay on HEAD
  # git -C $NG_REPO fetch origin refs/tags/$NG_RELEASE
  # git -C $NG_REPO checkout tags/$NG_RELEASE -b $NG_RELEASE
  set +x
  travis_fold end get_repos_ng
fi

if [[ -e "$ACX_REPO" ]]; then
  echo Angular components repo is already present at: $ACX_REPO
else
  travis_fold start get_repos_acx
  echo GETTING Angular components repo from GitHub ...
  set -x
  git clone https://github.com/dart-lang/angular_components.git $ACX_REPO
  git -C $ACX_REPO fetch origin refs/tags/$ACX_RELEASE
  git -C $ACX_REPO checkout tags/$ACX_RELEASE -b $ACX_RELEASE
  set +x
  travis_fold end get_repos_acx
fi

if [[ -e "$CEU_REPO" ]]; then
  echo $CEU_REPO repo is already present.
else
  travis_fold start get_repos_ceu
  echo GETTING repo from GitHub ...
  set -x
  git clone https://github.com/chalin/code_excerpt_updater.git $CEU_REPO
  (cd $CEU_REPO; pub get)
  set +x
  travis_fold end get_repos_ceu
fi

echo PWD `pwd`
echo INSTALLED repos:
ls -ld ../a*
