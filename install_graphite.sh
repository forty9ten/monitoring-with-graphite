#!/bin/sh

set -e

SCRIPT_PATH=$( cd "$( dirname "$0" )" && pwd )
CONF="$SCRIPT_PATH/conf"

$SCRIPT_PATH/install_collectd.sh

VERSION="0.9.12"

apt-get install -y python-setuptools python-cairo python-django python-django-tagging python-twisted python-zope.interface fontconfig apache2 libapache2-mod-wsgi python-pysqlite2 python-simplejson python-pyparsing python-txamqp python-ldap git-core memcached

easy_install pytz python-memcached python-ldap

for COMPONENT in whisper carbon graphite-web; do
  git clone http://github.com/graphite-project/${COMPONENT}.git
  cd $COMPONENT
    git checkout -q $VERSION
    python setup.py install
  cd -
done

cd /opt/graphite/conf
  cp graphite.wsgi.example graphite.wsgi
  cp $CONF/storage-aggregation.conf storage-aggregation.conf
  cp $CONF/storage-schemas.conf storage-schemas.conf
  cp $CONF/carbon.conf carbon.conf
cd -

cp $CONF/graphite /etc/apache2/sites-available

a2dissite 000-default
a2ensite graphite

service apache2 reload

cd /opt/graphite/webapp/graphite
  cp $CONF/initial_data.json $CONF/local_settings.py .
  sed -i -e "s/UNSAFE_DEFAULT/`date | md5sum | cut -d ' ' -f 1`/" local_settings.py
  python manage.py syncdb --noinput
cd -

groupadd -g 2000 carbon
useradd -g 2000 -u 2000 -s /bin/false carbon

cd /opt/graphite/storage
  chown www-data . graphite.db
  chown -R www-data log
  chown -R carbon whisper rrd
cd -

/opt/graphite/bin/carbon-cache.py start
