#!/bin/bash

NODE_NAME=${SERVICE_NAME:-etcd01}

[[ $DEBUG ]] && set -x


sleep ${PAUSE:-0}


exec /opt/goodrain/etcd/etcd --name=${NODE_NAME} --data-dir /data/