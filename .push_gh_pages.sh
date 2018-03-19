#!/bin/bash

rm -rf out || exit 0;
mkdir out;

GH_REPO="@github.com/ELIFE-ASU/rinform.git"

FULL_REPO="https://$GH_TOKEN$GH_REPO"

for files in '*.tar.gz'; do
        tar xfz $files
done

cd out
git init
git config user.name "ELIFE-ASU-travis"
git config user.email "travis"
$ git pull origin gh-pages
cp ../rinform/inst/doc/rinform-vignette.html index.html

git add .
git commit -m "deployed to github pages"
git push --quiet $FULL_REPO master:gh-pages
