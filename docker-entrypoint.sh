#!/bin/bash

NODE_NAME=${SERVICE_NAME:-etcd01}


[[ $DEBUG ]] && set -x

cd $TIDB_HOME
SELF_IP=$(ping -c 1 `hostname`|head -n 1 | awk -F '[()]' '{print $2}')
SELF_ID=${HOSTNAME##*-}
HOST_NAME=`hostname -f`

peers=`net lookupsrv -h $SERVICE_NAME --format http://%s:4001`

if [[ x$peers == x ]]; then
  start_cmd="--initial-cluster pd$SELF_ID=http://$HOST_NAME:4001"
else
  start_cmd="--join $peers"
  sleep 3
fi

# sleep ${PAUSE:-0}


exec /opt/goodrain/etcd/etcd \
     --name="pd$SELF_ID" \
     --data-dir /data/  \
     --listen-client-urls http://$SELF_IP:2379,http://127.0.0.1:2379 \
     --advertise-client-urls http://$SELF_IP:2379,http://$SELF_IP:4001 \
     --initial-advertise-peer-urls http://$HOST_NAME:4001 \
     --listen-peer-urls http://$HOST_NAME:4001 \
     --initial-cluster-token etcd-cluster-1 \
     --initial-cluster-state new \
     $start_cmd
      

