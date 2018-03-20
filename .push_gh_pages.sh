#!/bin/bash

rm -rf out || exit 0;
mkdir out;

GH_REPO="@github.com/ELIFE-ASU/rinform.git"

FULL_REPO="https://$GH_TOKEN$GH_REPO"

for files in '*.tar.gz'; do
        tar xfz $files
done

echo $GH_TOKEN
cd out
git init
git config user.name "Gabriele Valentini"
git config user.email "gabriele.valentini.85@gmail.com"
git clone https://github.com/ELIFE-ASU/rinform.git
cd rinform
git checkout gh-pages
cp ../../rinform/inst/doc/rinform-vignette.html index.html

git add .
git commit -m "deployed to github pages"
git push --force --quiet $FULL_REPO master:gh-pages
