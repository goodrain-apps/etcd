#!/bin/bash

[[ $DEBUG ]] && set -x

SELF_IP=$(ping -c 1 `hostname`|head -n 1 | awk -F '[()]' '{print $2}')
SELF_ID=${HOSTNAME##*-}
HOST_NAME=`hostname -f`

chmod +x /usr/bin/net
peers=`net lookupsrv -h $SERVICE_NAME --format http://%s:2380`

if [[ x$peers == x ]]; then
  start_cmd="--initial-cluster pd$SELF_ID=http://$HOST_NAME:2380"
else
  start_cmd="--initial-cluster,$peers"
  sleep 3
fi

# sleep ${PAUSE:-0}


exec /opt/goodrain/etcd/etcd \
     --name="pd$SELF_ID" \
     --data-dir /data/  \
     --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
     --advertise-client-urls http://$SELF_IP:2379,http://$SELF_IP:4001 \
     --initial-advertise-peer-urls http://$HOST_NAME:2380 \
     --listen-peer-urls http://0.0.0.0:2380 \
     --initial-cluster-token etcd-cluster-1 \
     --initial-cluster-state new \
     $start_cmd
      

