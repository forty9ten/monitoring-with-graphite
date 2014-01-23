#!/bin/sh

set -e

SCRIPT_PATH=$( cd "$( dirname "$0" )" && pwd )
CONF="$SCRIPT_PATH/conf"

apt-add-repository -y ppa:chris-lea/node.js
apt-get update \
  -o Dir::Etc::sourcelist="sources.list.d/chris-lea-node_js-precise.list" \
  -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
apt-get install -y nodejs git-core

cd /usr/share
  git clone https://github.com/etsy/statsd.git
  cd statsd
    git reset --hard 64388f4c8d
  cd -
cd -

mkdir /etc/statsd

eval "echo \"$(sed 's/\"/\\"/g' "$CONF/statsdConfig.js")\"" > /etc/statsd/localConfig.js

cp /usr/share/statsd/debian/statsd.init /etc/init.d/statsd
chmod +x /etc/init.d/statsd

groupadd -g 3000 _statsd
useradd -g 3000 -u 3000 -s /bin/false _statsd

update-rc.d statsd defaults

service statsd start
