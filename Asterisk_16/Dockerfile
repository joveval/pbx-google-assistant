# Base image for compiling
FROM debian:buster

# Mantainers
LABEL maintainer="José Valenzuela Soto <jose.valenzuela@botit.io>"

# GLOBALS
ENV ASTERISK_USER    asterisk
ENV ASTERISK_GROUP   asterisk
ENV RTP_START        10000
ENV RTP_END          10099
ENV AST_SRC_CODE     http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz
ENV OPUS_SRC_CODE    http://downloads.digium.com/pub/telephony/codec_opus/asterisk-16.0/x86-64/codec_opus-16.0_current-x86_64.tar.gz


# Install build dependencies
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-utils
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    libncurses5-dev \
    file \
    libedit-dev \
    libresample1-dev \
    libssl-dev \
    libxml2-dev \
    libsqlite3-dev \
    uuid-dev \
    libjansson-dev \
    vim-nox \
    curl

RUN mkdir -p /usr/src/asterisk & cd /usr/src/asterisk & curl -vsL ${AST_SRC_CODE} | tar --strip-components 1 -xz
RUN ./configure
RUN make && make install && make config && make samples
COPY install_perl.sh /
RUN chmod +x /install_perl.sh
RUN /install_perl.sh

EXPOSE 5060/udp

# Volumes needed to work with asterisk multiple instances
VOLUME /var/lib/asterisk/sounds /var/lib/asterisk/keys\
       /var/lib/asterisk/phoneprov /var/spool/asterisk\
       /var/log/asterisk /tmp/records /etc/dialogflow

# Copy relevant config and relevant files

COPY /*.json /etc/dialogflow/
COPY /config/*.conf /etc/asterisk/
COPY dflow.agi /var/lib/asterisk/agi-bin/dflow.agi
COPY /sounds/alexa*.sln /var/lib/asterisk/sounds/custom/
ENTRYPOINT ["/usr/sbin/asterisk"]
CMD ["-vvvdddnf", "-T", "-W", "-p"]