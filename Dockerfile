FROM gradle:5.2.1-jdk8

# Instll kafka-connect-jdbc from here
# confluent version of kafka need to be install before building common libraries
# https://github.com/confluentinc/kafka-connect-jdbc/wiki/FAQ
RUN curl https://github.com/apache/kafka/archive/2.3.0.zip -L -o kafka.zip \
    && unzip kafka.zip -d /tmp \
    && cd /tmp/kafka-2.3.0/ \
    && gradle wrapper \
    && ./gradlew clean installAll

USER root

# common libraries need to be installed before building JDBC Kafka connect
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install maven -y
RUN curl https://github.com/confluentinc/common/archive/v5.3.3.zip -L -o confluent-common.zip \
    && unzip ./confluent-common.zip -d /tmp/ \
    && cd /tmp/common-5.3.3/ \
    && mvn clean install

RUN curl https://github.com/dergraf/kafka-connect-elasticsearch/archive/5.3.3-with-prs.zip -L -o kafka-connect-elasticsearch.zip \
    && unzip kafka-connect-elasticsearch.zip -d /tmp/ \
    && cd /tmp/kafka-connect-elasticsearch-5.3.3-with-prs/ \
    && mvn clean package
