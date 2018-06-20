FROM java:8-alpine

RUN apk add --update ca-certificates && rm -rf /var/cache/apk/* && \
  find /usr/share/ca-certificates/mozilla/ -name "*.crt" -exec keytool -import -trustcacerts \
  -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts -storepass changeit -noprompt \
  -file {} -alias {} \; && \
  keytool -list -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts --storepass changeit

RUN apk add --update openssl

ENV MAVEN_VERSION 3.5.3
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Download and install Vocbench 
RUN wget https://bitbucket.org/art-uniroma2/vocbench3/downloads/vocbench3-3.0.1-full.zip && unzip ./vocbench3-3.0.1-full.zip
RUN chmod +x /usr/src/app/semanticturkey-3.0/bin/st_server_run

CMD /usr/src/app/semanticturkey-3.0/bin/st_server_run

EXPOSE 1979
