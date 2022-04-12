FROM andrius/asterisk

EXPOSE 8088

COPY sounds/. /var/lib/asterisk/sounds/.
COPY conf/. /etc/asterisk/.
COPY docker-entrypoint.sh /docker-entrypoint.sh