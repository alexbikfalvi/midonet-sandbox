#!/bin/bash

# Default mido_zookeeper_key
if [ -z "$MIDO_ZOOKEEPER_ROOT_KEY" ]; then
    MIDO_ZOOKEEPER_ROOT_KEY=/midonet/v1
fi

# Update ZK hosts in case they were linked to this container
if [[ `env | grep _PORT_2181_TCP_ADDR` ]]; then
    MIDO_ZOOKEEPER_HOSTS="$(env | grep _PORT_2181_TCP_ADDR | sed -e 's/.*_PORT_2181_TCP_ADDR=//g' -e 's/^.*/&:2181/g' | sort -u)"
    MIDO_ZOOKEEPER_HOSTS="$(echo $MIDO_ZOOKEEPER_HOSTS | sed 's/ /,/g')"
fi

if [ -z "$MIDO_ZOOKEEPER_HOSTS" ]; then
    echo "No Zookeeper hosts specified neither by ENV VAR nor by linked containers"
    exit 1
fi

echo "Configuring tools using MIDO_ZOOKEEPER_HOSTS: $MIDO_ZOOKEEPER_HOSTS"
echo "Configuring tools using MIDO_ZOOKEEPER_ROOT_KEY: $MIDO_ZOOKEEPER_ROOT_KEY"

mkdir /etc/midonet
cat << EOF > /etc/midonet/midonet.conf
[zookeeper]
zookeeper_hosts = $MIDO_ZOOKEEPER_HOSTS
root_key = $MIDO_ZOOKEEPER_ROOT_KEY
EOF


mn-conf set -t default <<EOF
zookeeper.zookeeper_hosts="$MIDO_ZOOKEEPER_HOSTS"
state_proxy.enabled=true
EOF

echo "Starting tools!"
exec /sbin/init
