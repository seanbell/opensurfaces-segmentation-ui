#!/bin/bash

SRC_DIR=example_project/segmentation/static/
JS_DIR=$SRC_DIR/js
BUILD_DIR=static

mkdir -p $BUILD_DIR/js $BUILD_DIR/css $BUILD_DIR/img

# the order in which they are concatenated is important
echo "Merging javascript..."
cat $JS_DIR/lib/jquery-1.8.2.min.js \
	$JS_DIR/lib/jquery-ui-1.9.1.custom.min.js \
	$JS_DIR/lib/bootstrap-2.2.1.min.js \
	$JS_DIR/lib/json2.js \
	$JS_DIR/lib/csrf.js \
	$JS_DIR/lib/jquery.hotkeys.js \
	$JS_DIR/lib/kinetic-v4.3.3.min.js \
	$JS_DIR/lib/delaunay.js \
	> static/js/build-js.js

# the order in which these files are concatenated is important
echo "Compiling coffeescript..."
coffee --bare \
	--join static/js/build-coffee.js \
	--compile \
		$JS_DIR/common/hacks.coffee \
		$JS_DIR/common/modals.coffee \
		$JS_DIR/common/scroll.coffee \
		$JS_DIR/common/ui_events.coffee \
		$JS_DIR/common/util.coffee \
		$JS_DIR/common/geom.coffee \
		$JS_DIR/common/actions.coffee \
		$JS_DIR/common/active_timer.coffee \
		$JS_DIR/common/get_url_params.coffee \
		$JS_DIR/poly/actions.coffee \
		$JS_DIR/poly/controller_state.coffee \
		$JS_DIR/poly/controller_ui.coffee \
		$JS_DIR/poly/stage_ui.coffee \
		$JS_DIR/poly/polygon_ui.coffee \
		$JS_DIR/mturk/mt_submit.coffee \
		$JS_DIR/mturk/mt_segment_material.coffee

echo "Copying jss, css, img..."
cp -r $SRC_DIR/css $SRC_DIR/img static

echo "Running webserver..."
python2.7 -m SimpleHTTPServer
