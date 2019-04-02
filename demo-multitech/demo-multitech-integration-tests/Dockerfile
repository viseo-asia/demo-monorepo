# BUILD
FROM node:10-alpine as builder

RUN apk add --no-cache bash git python perl alpine-sdk

WORKDIR /opt/app

COPY . .

RUN npm install && \ 
    npm audit


# RUN
FROM node:10-alpine

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY --from=builder /opt/app /opt/app

WORKDIR /opt/app

CMD [ "/entrypoint.sh" ]
