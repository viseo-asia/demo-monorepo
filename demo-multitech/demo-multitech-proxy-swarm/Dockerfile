FROM nginx:1-alpine

RUN apk add nginx-mod-http-lua git && \
  rm -fr /etc/nginx/conf.d/* && \
  cd /opt/ && \
  git clone https://github.com/knyar/nginx-lua-prometheus

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf_vue.conf /etc/nginx/conf.d/
COPY metrics.conf /etc/nginx/conf.d/
