FROM whisk/java

MAINTAINER Viktor Taranenko, viktortnk@gmail.com

RUN apt-get update
RUN apt-get install -y curl

RUN echo "deb http://debian.datastax.com/community stable main" | tee -a /etc/apt/sources.list.d/datastax.sources.list
RUN curl -L http://debian.datastax.com/debian/repo_key | apt-key add -
RUN apt-get update
RUN apt-get install -y cassandra

ADD start.sh /usr/local/bin/cassandra-server
RUN chmod 755 /usr/local/bin/cassandra-server

EXPOSE 7199 7000 7001 9160 9042
USER root
CMD /usr/local/bin/cassandra-server

