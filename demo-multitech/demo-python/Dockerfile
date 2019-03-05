# BUILD
FROM python:3-alpine

COPY src /opt/app/src

WORKDIR /opt/app

RUN pip install Flask

CMD [ "python", "src/app.py" ]
