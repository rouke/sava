FROM busybox:latest

MAINTAINER tim@magnetic.io

# Vamp Sava showcase service _SERVICE_
# https://github.com/magneticio/sava

EXPOSE 8080

COPY public /public

COPY _SERVICE_ /

ENTRYPOINT ["/_SERVICE_"]
