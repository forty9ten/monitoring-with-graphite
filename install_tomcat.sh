#!/bin/sh

set -e

SCRIPT_PATH=$( cd "$( dirname "$0" )" && pwd )
CONF="$SCRIPT_PATH/conf"

apt-get install -y java7-runtime

cd /opt
  wget -N http://mirror.metrocast.net/apache/tomcat/tomcat-7/v7.0.50/bin/apache-tomcat-7.0.50.tar.gz
  tar xf apache-tomcat-7.0.50.tar.gz
  ln -s apache-tomcat-7.0.50 tomcat
cd -

cp $CONF/setenv.sh /opt/tomcat/bin

groupadd -g 4000 tomcat
useradd -g 4000 -u 4000 -s /bin/false tomcat

chown -R tomcat:tomcat /opt/tomcat/

sudo -u tomcat /opt/tomcat/bin/startup.sh
