#!/bin/sh

#add external ip in pjsip.conf
if [ "${ASTERISK_EXTERNAL_IP}" != "" ] && [ "${ASTERISK_EXTERNAL_PORT}" != "" ]; then
  echo "[transport-udp](+)"                               >  /etc/asterisk/pjsip_external_ip.conf
  echo "external_media_address=$ASTERISK_EXTERNAL_IP"     >> /etc/asterisk/pjsip_external_ip.conf
  echo "external_signaling_address=$ASTERISK_EXTERNAL_IP" >> /etc/asterisk/pjsip_external_ip.conf
  echo "external_signaling_port=$ASTERISK_EXTERNAL_PORT"  >> /etc/asterisk/pjsip_external_ip.conf
else
  echo "" >  /etc/asterisk/pjsip_external_ip.conf
fi

#add ari auth in ari.conf
if [ "${ARI_USER}" != "" ] && [ "${ARI_PASSWORD}" != "" ]; then
  echo "[$ARI_USER]"              >  /etc/asterisk/ari_auth.conf
  echo "type = user"              >> /etc/asterisk/ari_auth.conf
  echo "read_only = no"           >> /etc/asterisk/ari_auth.conf
  echo "password_format = plain"  >> /etc/asterisk/ari_auth.conf
  echo "password = $ARI_PASSWORD" >> /etc/asterisk/ari_auth.conf
else
  echo "" >  /etc/asterisk/ari_auth.conf
fi

# run as user asterisk by default
ASTERISK_USER=${ASTERISK_USER:-asterisk}
ASTERISK_GROUP=${ASTERISK_GROUP:-${ASTERISK_USER}}

if [ "$1" = "" ]; then
  COMMAND="/usr/sbin/asterisk -T -W -U ${ASTERISK_USER} -p -vvvvvvvf"
else
  COMMAND="$@"
fi

if [ "${ASTERISK_UID}" != "" ] && [ "${ASTERISK_GID}" != "" ]; then
  # recreate user and group for asterisk
  # if they've sent as env variables (i.e. to macth with host user to fix permissions for mounted folders

  deluser asterisk && \
  addgroup -g ${ASTERISK_GID} ${ASTERISK_GROUP} && \
  adduser -D -H -u ${ASTERISK_UID} -G ${ASTERISK_GROUP} ${ASTERISK_USER} \
  || exit
fi

chown -R ${ASTERISK_USER}: /var/log/asterisk \
                           /var/lib/asterisk \
                           /var/run/asterisk \
                           /var/spool/asterisk; \
exec ${COMMAND}