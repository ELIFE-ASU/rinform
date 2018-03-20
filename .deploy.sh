#!/bin/bash

rm -rf out || exit 0;
mkdir out;

for files in '*.tar.gz'; do
        tar xfz $files
done

cd out
cp ../rinform/inst/doc/rinfor-vignette.html index.html
