#!/bin/bash
PROGNAME=$(basename $0)

if test -z ${ASTERISK_VERSION}; then
  echo "${PROGNAME}: ASTERISK_VERSION required" >&2
  exit 1
fi

set -ex

useradd --system ${ASTERISK_USER}

######################################
# 1. Installing Sofware Requirements #
######################################

apt-get update
apt-get install -y \
        bison \
        wget \
        openssl \
        libssl-dev \
        libasound2-dev \
        libc6-dev \
        libxml2-dev \
        libsqlite3-dev \
        libnewt-dev \
        libncurses5-dev \
        zlib1g-dev \
        gcc \
        g++ \
        make \
        perl \
        uuid-dev \
        git \
        subversion \
        libjansson-dev \
        unixodbc-dev \
        unixodbc-bin \
        unixodbc \
        autoconf \
        libedit-dev


# Remove all unused packages
apt-get purge -y --auto-remove
rm -rf /var/lib/apt/lists/*
#########################################
# 2. Installing Asterisk Latest Version #
#########################################
mkdir -p /usr/src/asterisk
cd /usr/src/asterisk
wget -vsL http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}.tar.gz | tar --strip-components 1 -xz

./configure
make menuselect/menuselect menuselect-tree menuselect.makeopts
# Generally, Asterisk attempts to optimize itself for the machine on which it is built on. 
# On some virtual machines with virtual CPU architectures, 
# the defaults chosen by Asterisk's compilation options will cause Asterisk to build but fail to run.
# To disable native architecture support, disable the BUILD_NATIVE option in menuselect:
# menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts

 # download more sounds
 for i in CORE-SOUNDS-EN; do
     for j in WAV ALAW G722 GSM SLN16; do
         menuselect/menuselect --enable $i-$j menuselect.makeopts
     done
 done

# we don't need any sounds in docker, they will be mounted as volume
#menuselect/menuselect --disable-category MENUSELECT_CORE_SOUNDS menuselect.makeopts
#menuselect/menuselect --disable-category MENUSELECT_MOH menuselect.makeopts
#menuselect/menuselect --disable-category MENUSELECT_EXTRA_SOUNDS menuselect.makeopts

make && make install && make config && make samples

# Set rtp ranges
sed -i -E "s/(rtpstart=10000)/rtpstart=${RTP_START}/" /etc/asterisk/rtp.conf
sed -i -E "s/(rtpend=20000)/rtpend=${RTP_END}/" /etc/asterisk/rtp.conf

# Install opus

# mkdir -p /usr/src/codecs/opus \
#  && cd /usr/src/codecs/opus \
#  && curl -vsL http://downloads.digium.com/pub/telephony/codec_opus/${OPUS_CODEC}.tar.gz | tar --strip-components 1 -xz \
#  && cp *.so /usr/lib/asterisk/modules/ \
#  && cp codec_opus_config-en_US.xml /var/lib/asterisk/documentation/

# mkdir -p /etc/asterisk/ \
#         /var/lib/asterisk/ \
#         /var/spool/asterisk/ \
#         /var/log/asterisk/ \
#         /var/run/asterisk/

chown -R ${ASTERISK_USER}:${ASTERISK_GROUP} /etc/asterisk \
                                            /var/*/asterisk \
                                            /usr/*/asterisk
chmod -R 750 /var/spool/asterisk

cd /
rm -rf /usr/src/asterisk \
       /usr/src/codecs

# Remove *-dev packages
DEV_PACKAGES_PATTERN=`dpkg -l|grep '\-dev'|awk '{print $2}'|xargs`
apt-get --yes purge \
  build-essential \
  bzip2 \
  cpp \
  make \
  patch \
  perl \
  perl-modules \
  xz-utils \
  ${DEV_PACKAGES_PATTERN}
rm -rf /var/lib/apt/lists/*

exec rm -f /build.sh