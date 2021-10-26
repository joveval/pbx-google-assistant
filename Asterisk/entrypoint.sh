#!/bin/sh

# run as user asterisk by default
ASTERISK_USER=${ASTERISK_USER:-asterisk}
COMMAND="$@"
echo "command to entry: $COMMAND"
if [ "${ASTERISK_UID}" != "" ] && [ "${ASTERISK_GID}" != "" ]; then
  # recreate user and group for asterisk
  # if they've sent as env variables (i.e. to match with host user to fix permissions for mounted folders

  deluser asterisk && \
  adduser --gecos "" --no-create-home --uid ${ASTERISK_UID} --disabled-password ${ASTERISK_USER} || exit

  chown -R ${ASTERISK_UID}:${ASTERISK_UID} /etc/asterisk \
                                           /var/*/asterisk \
                                           /usr/*/asterisk
fi

exec ${COMMAND}