#!/bin/sh

set -e

cd /opt/learninglocker/
pm2 start pm2/all.json --hp /home/docker
cd /opt/xapi-service/
pm2 start pm2/xapi.json --hp /home/docker
pm2 logs