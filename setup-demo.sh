#!/bin/bash

# install python dependencies: django, django-compressor, ua-parser
sudo pip install "django>=1.4.3,<1.5" "django-compressor>=1.2,<2" "ua-parser>=0.3.2,<0.4"

# In the settings file (example_project/example_project/settings.py),
# automatically update the STATIC_ROOT variable to point to a temporary
# directory in the current repository.  It doesn't matter what the
# directory is, as long as it's writable and previously unused.
STATIC_ROOT=$(pwd)/tmp-static/
mkdir -p $STATIC_ROOT
sed -r -i -e "s|^\s*STATIC_ROOT\s*=.*$|STATIC_ROOT = '$STATIC_ROOT'|" \
	example_project/example_project/settings.py
