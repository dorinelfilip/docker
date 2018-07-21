#!/bin/sh
export PYTHONPATH=/opt/graphite/webapp:/opt/graphite/webapp/graphite
export DJANGO_SETTINGS_MODULE=graphite.settings
CHECK_FILE=/opt/graphite/post-setup-complete
LOCAL=/usr/local/bin
GUNICORN=/usr/bin/gunicorn

chmod +x $LOCAL/init_config.sh && $LOCAL/init_config.sh &&
( if [ ! -f "$CHECK_FILE" ] ; then
	echo "[graphite-web] Initializing Django (collectstatic & migrate)" \
	&& PYTHONPATH=/opt/graphite/webapp django-admin.py collectstatic --settings=graphite.settings --no-input \
	&& PYTHONPATH=/opt/graphite/webapp django-admin.py makemigrations account events dashboard url_shortener --settings=graphite.settings \
	&& PYTHONPATH=/opt/graphite/webapp django-admin.py migrate --settings=graphite.settings
    && echo "[graphite-web] Initializing local_settings.py and 'admin' user" \
    && $LOCAL/setup-local-settings.py && $LOCAL/post-setup-graphite-web.py \
	&& touch $CHECK_FILE
fi ) && (
    echo "[graphite-web] starting ..."
    $GUNICORN graphite_wsgi:application --workers 4 --bind 127.0.0.1:8000
)
