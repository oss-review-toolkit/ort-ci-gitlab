#!/bin/bash -e

echo "Cloning the ORT revision: '$ORT_REVISION' from public repository: $ORT_URL ..."

mkdir -p ort && cd ort

git init -q
git remote add origin $ORT_URL
git fetch -q --depth 1 origin $ORT_REVISION
git checkout -q FETCH_HEAD

echo "Starting to compile ORT 'cli' and 'helper-cli'."
./gradlew --no-daemon -q -x reporter-web-app:yarnBuild cli:installDist helper-cli:installDist
echo "Compiling ORT 'cli' and 'helper-cli' done."
mkdir -p $CI_PROJECT_DIR/bin
ln -s $CI_PROJECT_DIR/ort/cli/build/install/ort/bin/ort $CI_PROJECT_DIR/bin
ln -s $CI_PROJECT_DIR/ort/helper-cli/build/install/orth/bin/orth $CI_PROJECT_DIR/bin

echo "Setup ORT 'cli' binary '$CI_PROJECT_DIR/bin/ort' -> '$(readlink -f $CI_PROJECT_DIR/bin/ort)'."
echo "Setup ORT 'helper-cli' binary '$CI_PROJECT_DIR/bin/orth' -> '$(readlink -f $CI_PROJECT_DIR/bin/orth)'."
