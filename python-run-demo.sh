#!/bin/bash

SRC_DIR=example_project/segmentation/static/
BUILD_DIR=static

mkdir -p $BUILD_DIR/js $BUILD_DIR/css $BUILD_DIR/img

echo "Merging javascript..."
rm -f static/js/build-js.js
# the order in which they are concatenated is very important
for f in jquery-1.8.2.min.js jquery-ui-1.9.1.custom.min.js bootstrap-2.2.1.min.js json2.js csrf.js jquery.hotkeys.js kinetic-v4.3.3.min.js delaunay.js; do
	cat $SRC_DIR/js/lib/$f >> static/js/build-js.js
done

echo "Compiling coffeescript..."
cffee --bare --join static/js/build-coffee.js --compile $(find $SRC_DIR -name '*.coffee')

echo "Copying jss, css, img..."
cp -r $SRC_DIR/css $SRC_DIR/img static

echo "Running webserver..."
python -m SimpleHTTPServer
