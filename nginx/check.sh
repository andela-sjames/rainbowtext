#!/usr/bin/env bash
echo "$1"

if [[ $1 == "production" ]]; then
    echo "using default loopback address 127.0.0.1"
else
    cd /etc/nginx/
    rm -rf nginx.conf
    pwd && ls
    mv nginx.dev.conf nginx.conf
    echo "I was here"
    cat nginx.conf
    pwd && ls
fi
