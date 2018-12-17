#!/bin/sh
set -e

if [ "${DOMAIN}" == "**None**" ]; then
    echo "Please set DOMAIN"
    exit 1
fi

if [ ! -f "${MY_FILES}/bin/ngrok" ]; then
    echo "ngrok is not build, please build"
    exit 1
fi


${MY_FILES}/bin/ngrok -config ${MY_FILES}/ngrok.cfg start-all
