#!/bin/bash

[[ $DEBUG ]] && set -x


sleep ${PAUSE:-0}

exec /opt/goodrain/etcd/bin/etcd --data-dir /data/