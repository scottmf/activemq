FROM webcenter/openjdk-jre:8
MAINTAINER Scott Feldstein <scottf76@gmail.com>

# Update distro and install some packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install vim curl -y && \
    apt-get install supervisor -y && \
    apt-get install logrotate -y && \
    apt-get install locales -y && \
    update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    rm -rf /var/lib/apt/lists/*

# copy custom activemq.conf
COPY activemq.xml /var/tmp/

# Lauch app install
COPY assets/setup/ /app/setup/
RUN chmod +x /app/setup/install
RUN /app/setup/install

ARG zk_address=zoo1:2181,zoo2:2181,zoo3:2181
ENV ZKADDRESS=${zk_address}
RUN sed -e "s/##ZKADDRESS##/$ZKADDRESS/" /var/tmp/activemq.xml > /opt/activemq/conf/activemq.xml

# Copy the app setting
COPY assets/init.py /app/init.py
COPY assets/run.sh /app/run.sh
RUN chmod +x /app/init.py
RUN chmod +x /app/run.sh

# Expose all port
EXPOSE 8161
EXPOSE 61616
EXPOSE 5672
EXPOSE 61613
EXPOSE 1883
EXPOSE 61614
EXPOSE 61619

# Expose some folders
VOLUME ["/data/activemq"]
VOLUME ["/var/log/activemq"]
VOLUME ["/opt/activemq/conf"]

WORKDIR /opt/activemq

#ENTRYPOINT ["/app/init"]
CMD ["/app/run.sh"]
