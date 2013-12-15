#!/usr/bin/bash

# install dependencies
sdo pip install "django==1.4" "django-compressor==1.2" "ua-parser==0.3.2"

# update STATIC_ROOT in the local project settings
STATIC_ROOT=$(pwd)/tmp-static/
mkdir -p $STATIC_ROOT
sed -r -i \
	-e "s/^\s*STATIC_ROOT\s*=.*$/STATIC_ROOT = '$STATIC_ROOT'/" \
	example_project/example_project/settings.py
