FROM aurelbruno06/jdk:1.7
MAINTAINER Aurelien Bruno <aurelbruno06@gmail.com>
ENV ES_VERSION 2.3.3
# modify Dockerfile from the official one to allow cluster building
# Need gosu to make it work
ENV GOSU_VERSION 1.8
RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
&& gosu nobody true

RUN wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/${ES_VERSION}/elasticsearch-${ES_VERSION}.deb  && dpkg -i elasticsearch-${ES_VERSION}.deb && rm elasticsearch-${ES_VERSION}.deb

ENV CLUSTER_NAME "demo"
ENV NODE_NAME "node1"
ENV NODE_IS_MASTER "true"
ENV NODE_IS_DATA "true"
ENV INDEX_SHARDS 1
ENV INDEX_REPLICAS 0
ENV RACK_ENV_VAR rack1
ENV VERSION 1.0.12
RUN echo $VERSION > /tmp/version

#RUN groupadd -r elasticsearch && useradd -r --create-home --home-dir $HOME -g elasticsearch elasticsearch
#RUN mkdir /home/elasticsearch && chown elasticsearch:elasticsearch /home/elasticsearch

ENV PATH /usr/share/elasticsearch/bin:$PATH
WORKDIR /usr/share/elasticsearch
RUN set -ex \
	&& for path in \
		./data \
		./logs \
		./config \
		./config/scripts \
	; do \
		mkdir -p "$path"; \
		chown -R elasticsearch:elasticsearch "$path"; \
done
ADD files/ ./config
ADD init.sh /root/init.sh
EXPOSE "9200" "9300"
ENTRYPOINT ["/root/init.sh"]
