#!/bin/bash

IP=$(hostname -I | cut -f1 -d' ')
ARI_PASSWORD=$(openssl rand -base64 32)
REDIS_PASSWORD=$(openssl rand -base64 32)

echo "ASTERISK_EXTERNAL_IP=$IP"    > .env
echo "ASTERISK_EXTERNAL_PORT=5060" >> .env

echo "ARI_URL=http://asterisk:8088/" >> .env
echo "ARI_USER=ARI_USER" >> .env
echo "ARI_PASSWORD=$ARI_PASSWORD" >> .env

echo "REDIS_URL=redis://redis" >> .env
echo "REDIS_PASSWORD=$REDIS_PASSWORD" >> .env