#!/bin/bash

SRC_DIR=example_project/segmentation/static
BUILD_DIR=static

JS_DIR=$SRC_DIR/js
CSS_DIR=$SRC_DIR/css
IMG_DIR=$SRC_DIR/img

# NOTE: the order in which these files are listed is important, as there are
# dependencies between the libraries.

JS_LIB_FILES="
	$JS_DIR/lib/jquery-1.8.2.min.js
	$JS_DIR/lib/jquery-ui-1.9.1.custom.min.js
	$JS_DIR/lib/bootstrap-2.2.1.min.js
	$JS_DIR/lib/json2.js
	$JS_DIR/lib/csrf.js
	$JS_DIR/lib/jquery.hotkeys.js
	$JS_DIR/lib/kinetic-v4.3.3.min.js
	$JS_DIR/lib/delaunay.js
"

COFFEE_FILES="
	$JS_DIR/common/hacks.coffee
	$JS_DIR/common/modals.coffee
	$JS_DIR/common/scroll.coffee
	$JS_DIR/common/ui_events.coffee
	$JS_DIR/common/util.coffee
	$JS_DIR/common/geom.coffee
	$JS_DIR/common/actions.coffee
	$JS_DIR/common/active_timer.coffee
	$JS_DIR/common/get_url_params.coffee
	$JS_DIR/poly/actions.coffee
	$JS_DIR/poly/controller_state.coffee
	$JS_DIR/poly/controller_ui.coffee
	$JS_DIR/poly/stage_ui.coffee
	$JS_DIR/poly/polygon_ui.coffee
	$JS_DIR/mturk/mt_submit.coffee
	$JS_DIR/mturk/mt_segment_material.coffee
"

CSS_FILES="
	$CSS_DIR/jquery-ui-1.9.1.custom.min.css
	$CSS_DIR/bootstrap-2.2.1.min.css
	$CSS_DIR/mturk.css
"

mkdir -p $BUILD_DIR/js $BUILD_DIR/css $BUILD_DIR/img

echo "Compiling coffeescript..."
coffee --bare --join build-coffee.js --compile $COFFEE_FILES

echo "Merging javascript..."
# note that the JS library files are included before the compiled coffeescript
cat $JS_LIB_FILES build-coffee.js > $BUILD_DIR/js/opensurfaces-segmentation-ui.js

echo "Merging css..."
cat $CSS_FILES > $BUILD_DIR/css/opensurfaces-segmentation-ui.css

echo "Copying images..."
cp -r $IMG_DIR $BUILD_DIR

echo "Cleanup..."
rm build-coffee.js

echo "Running webserver..."
python2.7 -m SimpleHTTPServer
