# opensurfaces-segmentation-ui
Segmentation UI from the OpenSurfaces Project

## Short version
1. Setup and run the demo:
<pre>
sudo ./setup-demo.sh
./run-demo.sh
</pre>

2. Open a web browser and visit `localhost:8000`

## Long version
Install Python dependencies:
<pre>
sudo pip install "django>=1.4.3,<1.5" "django-compressor>=1.2,<2" "ua-parser>=0.3.2,<0.4"
</pre>

The demo project is written for Django 1.4, though it probably will work with
other versions since it uses almost no django APIs.

### If you are building around this codebase:
In `example_project/settings.py`, change `SECRET_KEY` to some
random string.

### If you are adding this to your own Django project:
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
