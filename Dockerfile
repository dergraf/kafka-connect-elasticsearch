FROM gradle:5.2.1-jdk8

# Instll kafka-connect-jdbc from here
# confluent version of kafka need to be install before building common libraries
# https://github.com/confluentinc/kafka-connect-jdbc/wiki/FAQ
RUN curl https://github.com/apache/kafka/archive/2.4.0.zip -L -o kafka.zip \
    && unzip kafka.zip -d /tmp \
    && cd /tmp/kafka-2.4.0/ \
    && gradle wrapper \
    && ./gradlew clean installAll

USER root

# common libraries need to be installed before building JDBC Kafka connect
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install maven -y
RUN curl https://github.com/confluentinc/common/archive/v5.4.1.zip -L -o confluent-common.zip \
    && unzip ./confluent-common.zip -d /tmp/ \
    && cd /tmp/common-5.4.1/ \
    && mvn clean install

ADD . /tmp/kafka-connect-elasticsearch

WORKDIR /tmp/kafka-connect-elasticsearch

RUN mvn clean package -DskipTests
