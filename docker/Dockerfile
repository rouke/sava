FROM dockerfile/ubuntu

MAINTAINER drago@magnetic.io

# Vamp Sava showcase service _SERVICE_
# https://github.com/magneticio/sava

# Install Java 8
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

COPY _SERVICE_.jar /

EXPOSE 8080

CMD ["java", "-jar", "/_SERVICE_.jar"]

