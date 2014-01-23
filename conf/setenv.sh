#!/bin/sh

export JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"

export CATALINA_OPTS=" \
  -Dscalate.allowReload=false \
  -Djava.net.preferIPv4Stack=true \
  -Dcom.sun.management.jmxremote \
  -Dcom.sun.management.jmxremote.port=7500 \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -XX:+CMSClassUnloadingEnabled \
  -XX:+CMSPermGenSweepingEnabled \
"
