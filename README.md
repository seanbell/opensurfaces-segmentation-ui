# OpenSurfaces Segmentation UI
This repository contains the segmentation user interface from the
[OpenSurfaces](http://opensurfaces.cs.cornell.edu) project, extracted as a
lightweight tool.  A dummy server backend is included to run the demo.

![](https://github.com/seanbell/opensurfaces-segmentation-ui/blob/master/screenshot.png?raw=true)

To run the demo, there are two versions: one with django, and one without.  The
django version uses a dummy django server and compiles the website live as
necessary.  The non-django version is a flat html file extracted from the
django version.

## Version 1: Run with Django (Ubuntu Linux)

1. Install dependencies (coffee-script, django, django compressor, ua parser):
<pre>
./django-setup-demo.sh
</pre>

2. Start the local webserver:
<pre>
./django-run-demo.sh
</pre>

3. Visit `localhost:8000` in a web browser

To get the demo to work on Mac and Windows, you will have to look at
`setup-demo.sh` and run the equivalent commands for your system.

After drawing 6 polygons, the submit button will show you the POST data
that would have been sent to the server.

## Version 2: Run without Django (Linux or Mac)

To set up the static files (js, css, img) and then start a local python-based
webserver, run
<pre>
./python-run-demo.sh
</pre>
and then visit the printed URL (usually `0.0.0.0:8000`) in a web browser.

To get the demo to work on Windows, you will have to look at `setup-demo.sh`
and run the equivalent commands for your system.

## Project Notes

#### Django version
The demo project is written for Django 1.4, though it probably will work with
other versions since it uses almost no django APIs.

#### Compiling from coffeescript
The javascript for the tool is compiled from coffeescript files by
`django-compressor` and accessed by the client at a url of the form
`/static/cache/js/*.js`.  Look at the `python-run-demo.sh` script for an
example of manually compiling coffeescript files.

#### Local `/static/` folder
After you run the demo setup, the directory `static` will contain compiled css
and javascript files.  If you change any part of the page (other than html),
you will need to repopulate the static folder with the command:
<pre>
    example_project/manage.py collectstatic --noinput
</pre>

#### If you are building on top of this repository:
In `example_project/settings.py`, change `SECRET_KEY` to some
random string.

#### If you want to add this demo to your own (separate) Django project:
In `example_project/settings.py`, make the following changes:

1. Make sure `STATIC_ROOT` is set to an absolute writeable path.

2. Add this to the `STATICFILES_FINDERS` tuple:
<pre>
	'compressor.finders.CompressorFinder',
</pre>

3. Add this to the `INSTALLED_APPS` tuple:
<pre>
	'django.contrib.humanize',
	'compressor',
	'segmentation'
</pre>

4. Add this to `settings.py` (e.g. at the end):
<pre>
	# Django Compressor
	COMPRESS_ENABLED = True
	COMPRESS_OUTPUT_DIR = 'cache'
	COMPRESS_PRECOMPILERS = (
		('text/coffeescript', 'coffee --bare --compile --stdio'),
		('text/less', 'lessc -x {infile} {outfile}'),
	)
</pre>
