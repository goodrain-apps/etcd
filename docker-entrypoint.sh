#!/bin/bash

[[ $DEBUG ]] && set -x

SELF_IP=$(ping -c 1 `hostname`|head -n 1 | awk -F '[()]' '{print $2}')
SELF_ID=${HOSTNAME##*-}
HOST_NAME=`hostname -f`

chmod +x /usr/bin/net
peers=`net lookupsrv -h $SERVICE_NAME --wrap`

if [[ x$peers == x ]]; then
    start_cmd="--initial-cluster node$SELF_ID=http://$HOST_NAME:2380"
    start_state="new"
else
    peers_http=""
    for peer in $peers; do
    id=${peer%%.*}
    id=${id##*-}
    peer2="node${id}=http://${peer}:2380"

if [[ x$peers_http == x ]]; then
    peers_http="$peer2"
else
    peers_http="${peers_http},$peer2"
fi

done

    start_cmd="--initial-cluster $peers_http,node$SELF_ID=http://$HOST_NAME:2380"
    start_state="existing"
    sleep 3
fi

echo $start_cmd

exec /opt/goodrain/etcd/etcd \
     --name="node$SELF_ID" \
     --data-dir /data/  \
     --listen-client-urls http://0.0.0.0:2379 \
     --advertise-client-urls http://$SELF_IP:2379 \
     --initial-advertise-peer-urls http://$HOST_NAME:2380 \
     --listen-peer-urls http://0.0.0.0:2380 \
     --initial-cluster-token etcd-cluster-1 \
     --initial-cluster-state $start_state \
     $start_cmd
