#!/bin/sh

set -e

SCRIPT_PATH=$( cd "$( dirname "$0" )" && pwd )
CONF="$SCRIPT_PATH/conf"

apt-get install -y python-software-properties
apt-add-repository -y ppa:octplane/collectd
apt-get update \
  -o Dir::Etc::sourcelist="sources.list.d/octplane-collectd-precise.list" \
  -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

RUNLEVEL=1 apt-get install -y --force-yes collectd

eval "echo \"$(sed 's/\"/\\"/g' "$CONF/$ROLE.collectd.conf")\"" > /etc/collectd/collectd.conf

service collectd start
