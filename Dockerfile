FROM goodrainapps/alpine:3.4

ENV ETCD_VER=2.3.7

RUN mkdir -pv /opt/goodrain \
    && curl -s https:/pkg.goodrain.com/apps/etcd/etcd-v2.3.7-linux-amd64.tar.gz | tar -xz -C /opt/goodrain \
    && ln -s /opt/goodrain/etcd-v2.3.7-linux-amd64 /opt/goodrain/etcd

VOLUME [ "/data" ]

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]