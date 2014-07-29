#!/bin/bash

IP=`hostname --ip-address`

echo "Listening on: "$IP

export MAX_HEAP_SIZE="1G"
export HEAP_NEWSIZE="256M"

# Setup Cassandra
CONFIG=/etc/cassandra/
sed -i -e "s/^listen_address.*/listen_address: $IP/"            $CONFIG/cassandra.yaml
sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/"              $CONFIG/cassandra.yaml
sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$IP\"/"       $CONFIG/cassandra.yaml
sed -i -e "s/# JVM_OPTS=\"$JVM_OPTS -Djava.rmi.server.hostname=<public name>\"/ JVM_OPTS=\"$JVM_OPTS -Djava.rmi.server.hostname=$IP\"/" $CONFIG/cassandra-env.sh

# Start Cassandra
echo Starting Cassandra...
cassandra -f -p /var/run/cassandra.pid

