# https://github.com/elastic/elasticsearch-docker
FROM docker.elastic.co/elasticsearch/elasticsearch:6.3.2

COPY ./config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
COPY ./scripts /usr/share/elasticsearch/scripts

USER root 
RUN chmod +x /usr/share/elasticsearch/scripts/delete_old_index.sh
USER elasticsearch
