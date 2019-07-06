#!/usr/bin/env bash
echo "$1"

if [[ $1 == "production" ]]; then
    echo "using default loopback address 127.0.0.1"
else
    cd /etc/nginx/
    rm -rf nginx.conf
    mv nginx.dev.conf nginx.conf
fi
