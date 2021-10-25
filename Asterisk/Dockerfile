
# Base image
FROM alpine:3.14

# Mantainers
LABEL maintainer="José Valenzuela Soto <jose.valenzuela@botit.io>"


# Asterisk: http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz
# OPUS: http://downloads.digium.com/pub/telephony/codec_opus/asterisk-18.0/x86-64/codec_opus-18.0_current-x86_64.tar.gz
ENV ASTERISK_VERSION 18-current
ENV OPUS_CODEC       asterisk-18.0/x86-64/codec_opus-18.0_current-x86_64
ENV ASTERISK_USER    asterisk
ENV ASTERISK_GROUP   asterisk  
ENV RTP_START        10000
ENV RTP_END          10099

COPY build.sh /
RUN build.sh

EXPOSE 5060/udp 5060/tcp

# Volumes needed to work with asterisk multiple instances
VOLUME /var/lib/asterisk/sounds /var/lib/asterisk/keys\
/var/lib/asterisk/phoneprov /var/spool/asterisk\    			  		 
/var/log/asterisk

# Copy relevant config and relevant files
COPY entrypoint.sh /
COPY /config/*.conf /etc/asterisk/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/asterisk"]  