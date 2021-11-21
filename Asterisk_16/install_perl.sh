#!/bin/bash

set -ex

apt-get -y install sox
apt-get -y install libsox-fmt-mp3
apt-get -y install libwww-perl libjson-perl
apt-get -y install flac
cpanm IO::Socket::SSL --force
perl -MCPAN -e 'install JSON'
perl -MCPAN -e "install REST::Client"
perl -MCPAN -e "install Crypt::JWT"
perl -MCPAN -e "install MIME::Base64"
apt-get -y install libjson-pp-perl

exec rm -f /install_perl.sh


