#!/usr/bin/env bash

set -e -o pipefail

cd `dirname $0`/..

if [[ "$(node --version)" < "v6" ]]; then
    echo "ERROR: bad version of node detected. If you have nvm installed, type:"
    echo "  nvm use"
    echo "Aborting installation."
    exit 1;
else
    echo "Node version: $(node --version)"
fi

travis_fold start install.npm_install
(set -x; npm install --no-optional)
travis_fold end install.npm_install

if [ -z "$TRAVIS" ]; then
  echo "Rebuilding node-sass, just in case."
  (set -x; npm rebuild node-sass)
fi

travis_fold start install.bundle
(set -x; bundle install)
travis_fold end install.bundle

if [[ "$CI_TASK" == e2e* ]]; then
  ./scripts/examples-install.sh
fi

echo "Installation done"