FROM nginx:1-alpine

RUN rm -fr /etc/nginx/conf.d/*

COPY conf_vue.conf /etc/nginx/conf.d/
COPY conf_react.conf /etc/nginx/conf.d/
COPY conf_angular.conf /etc/nginx/conf.d/
