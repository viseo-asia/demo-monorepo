# BUILD
FROM node:10-alpine as builder

RUN apk add --no-cache bash git python perl alpine-sdk

WORKDIR /opt/app

COPY . /opt/app/

RUN npm install && \
    npm run build


# RUN
FROM nginx:1-alpine as production

COPY --from=builder /opt/app/dist /var/www/html

COPY nginx/default.conf /etc/nginx/conf.d/
