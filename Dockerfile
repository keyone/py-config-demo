FROM python:alpine3.7

ARG user=keyone
ARG group=keyone
ARG uid=1000
ARG gid=1000

COPY . /app
WORKDIR /app

RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    addgroup -g ${gid} ${group} && \
    adduser -u ${uid} -G ${group} -s /bin/sh -D ${user} && \
    chown -R ${user}:${group} /app

EXPOSE 5000

USER ${user}

CMD ["gunicorn", "server:app", "-b", "0.0.0.0:5000", "--keep-alive", "0"]