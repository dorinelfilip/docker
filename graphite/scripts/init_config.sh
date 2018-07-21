#!/bin/sh

CHECK_FILE=/opt/graphite/conf/.init_done
LOCAL=/usr/local/bin

if [ ! -f "$CHECK_FILE" ] ; then
	echo "[graphite] Copy default config & run Django setup (collectstatic & migrations)" \
	&& cp /opt/graphite/initconfig/* /opt/graphite/conf/ \
	&& mv /opt/graphite/conf/local_settings.py /opt/graphite/webapp/graphite/ \
	&& mv /opt/graphite/conf/graphite_wsgi.py /opt/graphite/webapp/graphite/ \
	&& mv /opt/graphite/conf/nginx.conf /etc/nginx \
	&& mv /opt/graphite/conf/supervisord.conf /etc/supervisord.conf \
	&& touch $CHECK_FILE
fi
