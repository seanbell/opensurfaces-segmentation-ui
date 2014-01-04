# OpenSurfaces Segmentation UI
This repository contains the segmentation user interface from the
[OpenSurfaces](http://opensurfaces.cs.cornell.edu) project, extracted as a
lightweight tool.  A dummy server backend is included to run the demo.

You can also view the demo
[online](http://seanbell.ca/opensurfaces-segmentation-ui/).

![](https://github.com/seanbell/opensurfaces-segmentation-ui/blob/master/screenshot.png?raw=true)

To run the demo, there are two versions: one with django, and one with no
framework.  The django version uses a dummy django server and compiles the
website live as necessary.  The non-django version is a flat html file
extracted from the django version.

If you find this tool helpful, please cite our
[project](http://opensurfaces.cs.cornell.edu/publications):
<pre>
@inproceedings{bell13opensurfaces,
	author = "Sean Bell and Paul Upchurch and Noah Snavely and Kavita Bala",
	title = "OpenSurfaces: A Richly Annotated Catalog of Surface Appearance",
	booktitle = "SIGGRAPH Conf. Proc.",
	volume = "32",
	number = "4",
	year = "2013",
}
</pre>
and report any bugs using the [GitHub issue
tracker](https://github.com/seanbell/opensurfaces-segmentation-ui/issues).
Also, please "star" this project on GitHub; it's nice to see how many people
are using our code.

## Version 1: Run with Django (Ubuntu Linux)

1. Install dependencies (`coffee-script`, `django`, `django-compressor`,
   `ua-parser`, `BeautifulSoup`):

   <b>Note:</b> this will change your django current installation if you are
   not somewhere between `1.4.*` and `1.6.*`.  I suggest looking into the
   `virtualenv` package if this is a problem for you.
<pre>
./django-setup-demo.sh
</pre>

2. Start the local webserver:
<pre>
./django-run-demo.sh
</pre>

3. Visit `localhost:8000` in a web browser

To get the demo to work on Mac and Windows, you will have to look at the above
scripts and run the equivalent commands for your system.

After drawing 6 polygons, the submit button will show you the POST data
that would have been sent to the server.

## Version 2: Run without Django (Linux or Mac)

1. Install `npm` and `node.js`.  On Ubuntu, this is:
<pre>
sudo apt-get install npm nodejs
</pre>

2. Install `coffee-script`:
<pre>
sudo npm install -g coffee-script
</pre>

3. Build static files (js, css, img) and then start a local python-based
   webserver:
<pre>
./python-run-demo.sh
</pre>

4. Visit `localhost:8000` in a web browser

To get the demo to work on Windows, you will have to look at the above scripts
and run the equivalent commands for your system.

## Project Notes

#### POST data

When a user submits, the client will POST the data to the same URL.  On
success, the client expects the JSON response `{"message": "success", "result":
"success"}`.  The client will then notify the MTurk server that the task is
completed.  For more details, see
`example_project/segmentation/views.py`.

When a user submits, the POST will contain these fields:
<pre>
results: a dictionary mapping from the photo ID (which is just "1" in
	this example) to a list of polygons.  Example:
	{"1": [[x1,y1,x2,y2,x3,y3,...], [x1,y1,x2,y2,...]]}.
	Coordinates are scaled with respect to the source photo dimensions, so both
	x and y are in the range 0 to 1.

time_ms: amount of time the user spent (whether or not they were active)

time_active_ms: amount of time that the user was active in the current window

action_log: a JSON-encoded log of user actions

screen_width: user screen width

screen_height: user screen height

version: always "1.0"

feedback: omitted if there is no feedback; JSON encoded dictionary of the form:
{
	'thoughts': user's response to "What did you think of this task?",
	'understand': user's response to "What parts didn't you understand?",
	'other': user's response to "Any other feedback, improvements, or suggestions?"
}
</pre>

#### Feedback survey

When the user finishes the task, a popup will ask for feedback.  In the django
version, disable this by setting `ask_for_feedback` to `'false'` in the file
`example_project/segmentation/vies.py`.  In the non-django verfsion, update the
`window.ask_for_feedback` variable in `index.html`.

I recommend asking for feedback after the 2nd or 3rd time a user has submitted,
not the first time, and then not asking again (otherwise it gets annoying).
Users usually don't have feedback until they have been working for a little while.

#### Compiling from coffeescript
The javascript for the tool is automatically compiled from coffeescript files
by `django-compressor` and accessed by the client at a url of the form
`/static/cache/js/*.js`.  This is set up already if using django.

If not using django, the `python-run-demo.sh` does this for you by manually
compiling coffeescript files and storing them in the `/static/` folder.

#### Browser compatibility
This UI works in Chrome and Firefox only.  The Django version includes a
browser check that shows an error page if the user is not on Chrome or Firefox
or is on a mobile device.

#### Local `/static/` folder
After you run the demo setup, the directory `/static/` will contain compiled css
and javascript files.

If you are usikng django and change any part of the static files (js, css,
images, coffeescript), you will need to repopulate the static folder with this
command:
<pre>
example_project/manage.py collectstatic --noinput
</pre>

#### If you are building on top of this repository:
In `example_project/settings.py`:
  1. Change `SECRET_KEY` to some random string.
  2. Fill in the rest of the values (admin name, database, etc).

#### If you want to add this demo to your own (separate) Django project:
In your `settings.py` file, make the following changes:

1. Make sure `STATIC_ROOT` is set to an absolute writable path.

2. Add this to the `STATICFILES_FINDERS` tuple:
<pre>
	'compressor.finders.CompressorFinder',
</pre>

3. Add this to the `INSTALLED_APPS` tuple:
<pre>
	'django.contrib.humanize',
	'compressor',
	'segmentation',
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
