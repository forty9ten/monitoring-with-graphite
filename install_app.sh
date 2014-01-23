#!/bin/sh

set -e

SCRIPT_PATH=$( cd "$( dirname "$0" )" && pwd )
CONF="$SCRIPT_PATH/conf"

$SCRIPT_PATH/install_collectd.sh
$SCRIPT_PATH/install_statsd.sh
$SCRIPT_PATH/install_tomcat.sh

rm -rf /opt/tomcat/webapps/ROOT*

cp $SCRIPT_PATH/dist/demo-app_2.10-0.1.0-SNAPSHOT.war /opt/tomcat/webapps/ROOT.war
