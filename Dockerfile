FROM node:6.14.2-alpine

LABEL image=codejamninja/cors-server \
      maintainer="Jam Risser <jam@codejam.ninja> (https://codejam.ninja)" \
      base=alpine:3.6

RUN apk add --no-cache \
        tini \
        nginx
RUN apk add --no-cache --virtual build-deps \
        curl
RUN mkdir /run/nginx && \
        curl -L -o /etc/nginx/nginx.conf \
        https://raw.githubusercontent.com/nginxinc/docker-nginx/master/stable/alpine/nginx.conf

WORKDIR /tmp/app

COPY ./ ./
RUN mv docker/nginx.conf /etc/nginx/conf.d/default.conf && \
    mkdir -p /usr/local/sbin && \
    mv docker/entrypoint.sh /usr/local/sbin && \
    chmod +x /usr/local/sbin/entrypoint.sh && \
    mv public /opt/app && \
    rm -rf /tmp/app
RUN apk del build-deps

WORKDIR /opt/app

EXPOSE 8080

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/sbin/entrypoint.sh"]
