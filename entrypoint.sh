#!/bin/sh

set -o errexit
set -o nounset


/usr/local/bin/uwsgi --ini uwsgi.ini

echo ""
echo "$@"
