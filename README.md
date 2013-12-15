# OpenSurfaces Segmentation UI
This repository contains the segmentation tool, extracted from the
(OpenSurfaces)[http://opensurfaces.cs.cornell.edu] project as a lightweight
independent tool.  A dummy server backend is included to run the demo.

![](https://github.com/seanbell/opensurfaces-segmentation-ui/blob/master/screenshot.png?raw=true)

## Quickstart (Mac or Linux)
1. Install dependencies (django, django compressor, ua parser):
<pre>
sudo ./setup-demo.sh
</pre>

2. Start the local webserver:
<pre>
./run-demo.sh
</pre>

3. Open a web browser and visit `localhost:8000`

The demo should also work on Windows; I leave it up to you to figure out what
commands to run instead.

## Project Notes

The demo project is written for Django 1.4, though it probably will work with
other versions since it uses almost no django APIs.

#### Running the project without Django

The html for the demo is pieced together from a series of templates in
`example_project/segmentation/templates` by the Django template processor.  I
kept them separate for readability, but you can always convert them to a static
version by viewing the demo (at `localhost:8000`) and then saving the html
source as a static html file.

The javascript files are written in coffeescript and are compiled on the fly by
`django-compressor`.  You can compile the coffeescript to javascript (make sure
to include the `--bare` flag).

Otherwise, there is no inherent dependency on Django.

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
