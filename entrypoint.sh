#!/bin/sh

set -o errexit
set -o nounset


/usr/local/bin/uwsgi --http 0.0.0.0:5000 \
    --plugins python3 \
    --wsgi run:app \
    --master true \
    --processes 1 \
    --socket :5000 \
    --vacuum true \
    --die-on-term true \

echo ""
echo "$@"
