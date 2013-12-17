#!/bin/bash

SRC_DIR=example_project/segmentation/static/
BUILD_DIR=static

JS_DIR=$SRC_DIR/js
CSS_DIR=$SRC_DIR/css

mkdir -p \
	$BUILD_DIR/js \
	$BUILD_DIR/css \
	$BUILD_DIR/img

# the order in which these files are compiled is important
echo "Compiling coffeescript..."
coffee --bare \
	--join $BUILD_DIR/js/build-coffee.js \
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

# concatenate javascript libraries with the compiled coffeescript
# (the order in which they are concatenated is important)
echo "Merging javascript..."
cat $JS_DIR/lib/jquery-1.8.2.min.js \
	$JS_DIR/lib/jquery-ui-1.9.1.custom.min.js \
	$JS_DIR/lib/bootstrap-2.2.1.min.js \
	$JS_DIR/lib/json2.js \
	$JS_DIR/lib/csrf.js \
	$JS_DIR/lib/jquery.hotkeys.js \
	$JS_DIR/lib/kinetic-v4.3.3.min.js \
	$JS_DIR/lib/delaunay.js \
	$BUILD_DIR/js/build-coffee.js \
	> $BUILD_DIR/js/opensurfaces-segmentation-ui.js

# cleanup
rm $BUILD_DIR/js/build-coffee.js

echo "Merging css..."
cat $CSS_DIR/jquery-ui-1.9.1.custom.min.css \
	$CSS_DIR/bootstrap-2.2.1.min.css \
	$CSS_DIR/mturk.css \
	> $BUILD_DIR/css/opensurfaces-segmentation-ui.css

echo "Copying images"
cp -r $SRC_DIR/img $BUILD_DIR

echo "Running webserver..."
python2.7 -m SimpleHTTPServer
