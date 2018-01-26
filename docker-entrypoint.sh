#!/bin/bash

NODE_NAME=${SERVICE_NAME:-etcd01}

[[ $DEBUG ]] && set -x


sleep ${PAUSE:-0}


exec /opt/goodrain/etcd/etcd \
     --name=${NODE_NAME} \
     --data-dir /data/  \
     --listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
     --advertise-client-urls http://127.0.0.1:2379,http://127.0.0.1:4001 \
     --initial-advertise-peer-urls http://127.0.0.1:2380 \
     --listen-peer-urls http://0.0.0.0:2380 \
     --initial-cluster-token etcd-cluster-1 \
     --initial-cluster ${NODE_NAME}=http://127.0.0.1:2380 \
     --initial-cluster-state new
      

