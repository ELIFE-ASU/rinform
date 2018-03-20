#!/bin/bash

rm -rf out || exit 0;
mkdir out;

GH_REPO="ELIFE-ASU/rinform.git"

for files in '*.tar.gz'; do
        tar xfz $files
done

echo $GH_TOKEN

cd out
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"
git checkout -b gh-pages
cp ../rinform/inst/doc/rinform-vignette.html index.html
git add .
git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
git remote add origin-pages https://${GH_TOKEN}@github.com/${GH_REPO} > /dev/null 2>&1
git push --quiet --set-upstream origin-pages gh-pages 
