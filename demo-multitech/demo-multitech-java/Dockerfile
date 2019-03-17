# Builder
FROM openjdk:8-jdk-alpine as builder

RUN apk add --no-cache bash git maven alpine-sdk

WORKDIR /src

COPY . .

RUN mvn -Dmaven.test.failure.ignore clean package


# Production
FROM openjdk:8-jre-alpine

EXPOSE 80

COPY --from=builder /src/target/demo_java-0.1.0.jar /opt/app.jar

CMD java -jar /opt/app.jar --server.port=80
