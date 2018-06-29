FROM goodrainapps/alpine:3.4

ENV GRETCD_VER=3.2.15
ENV PATH=$PATH:/opt/goodrain/etcd
ENV PACKAGE_URL=https:/pkg.goodrain.com

RUN mkdir -pv /opt/goodrain \
    && curl -s ${PACKAGE_URL}/apps/etcd/etcd-v${GRETCD_VER}-linux-amd64.tar.gz | tar -xz -C /opt/goodrain \
    && ln -s /opt/goodrain/etcd-v${GRETCD_VER}-linux-amd64 /opt/goodrain/etcd

VOLUME [ "/data" ]
EXPOSE 2380 2379
COPY net /usr/bin/net
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
