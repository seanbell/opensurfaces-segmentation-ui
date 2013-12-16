#!/bin/bash

# install coffee-script dependencies (npm, node.js)
sudo apt-get install npm nodejs

# install coffee-script
sudo npm install -g coffee-script

# install python dependencies: django, django-compressor, ua-parser,
# BeautifulSoup
sudo pip install \
	"django>=1.4,<1.7" \
	"django-compressor>=1.3,<1.4" \
	"ua-parser>=0.3.2,<0.4" \
	"BeautifulSoup<4.0"

# In the settings file (example_project/example_project/settings.py),
# automatically update the STATIC_ROOT variable to point to a temporary
# directory in the current repository.  It doesn't matter what the
# directory is, as long as it's writable and previously unused.
STATIC_ROOT=$(pwd)/static/
mkdir -p $STATIC_ROOT
sed -r -i -e "s|^\s*STATIC_ROOT\s*=.*$|STATIC_ROOT = '$STATIC_ROOT'|" \
	example_project/example_project/settings.py

# Copy static files to the new directory
example_project/manage.py collectstatic --noinput
