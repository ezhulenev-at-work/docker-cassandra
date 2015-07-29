#!/usr/bin/env bash

# Get running container's IP
IP=`hostname --ip-address`
if [ $# == 1 ]; then SEEDS="$1,$IP";
else SEEDS="$IP"; fi

if [ ! -z "$CASSANDRA_CLUSTER_NAME" ]; then
  sed -i -e "s/^cluster_name.*/cluster_name: $CASSANDRA_CLUSTER_NAME/" $CASSANDRA_CONFIG/cassandra.yaml
fi

# Disable virtual nodes
sed -i -e "s/num_tokens/\#num_tokens/" $CASSANDRA_CONFIG/cassandra.yaml

sed -i -e "s/^rpc_address.*/rpc_address: $IP/" $CASSANDRA_CONFIG/cassandra.yaml
sed -i -e "s/# broadcast_rpc_address.*/broadcast_rpc_address: $IP/" $CASSANDRA_CONFIG/cassandra.yaml
sed -i -e "s/^start_rpc.*/start_rpc: false/" $CASSANDRA_CONFIG/cassandra.yaml

sed -i -e "s/# broadcast_address.*/broadcast_address: $IP/" $CASSANDRA_CONFIG/cassandra.yaml

# Be your own seed
sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$SEEDS\"/" $CASSANDRA_CONFIG/cassandra.yaml

# Listen on IP:port of the container
sed -i -e "s/^listen_address.*/listen_address: $IP/" $CASSANDRA_CONFIG/cassandra.yaml

# With virtual nodes disabled, we need to manually specify the token
echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.initial_token=0\"" >> $CASSANDRA_CONFIG/cassandra-env.sh

# Pointless in one-node cluster, saves about 5 sec waiting time
echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.skip_wait_for_gossip_to_settle=0\"" >> $CASSANDRA_CONFIG/cassandra-env.sh

# Most likely not needed
echo "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$IP\"" >> $CASSANDRA_CONFIG/cassandra-env.sh

exec cassandra -f
