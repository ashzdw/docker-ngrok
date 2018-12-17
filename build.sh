#!/bin/sh
set -e

if [ "${DOMAIN}" == "**None**" ]; then
    echo "Please set DOMAIN"
    exit 1
fi

# cert
cd ${MY_FILES}
if [ ! -f "${MY_FILES}/base.pem" ]; then
    openssl genrsa -out base.key 2048
    openssl req -new -x509 -nodes -key base.key -days 10000 -subj "/CN=${DOMAIN}" -out base.pem
    openssl genrsa -out device.key 2048
    openssl req -new -key device.key -subj "/CN=${DOMAIN}" -out device.csr
    openssl x509 -req -in device.csr -CA base.pem -CAkey base.key -CAcreateserial -days 10000 -out device.crt
fi
cp -r base.pem /ngrok/assets/client/tls/ngrokroot.crt

# compile server&client
cd /ngrok
make release-server release-client
GOOS=linux GOARCH=386 make release-client
GOOS=linux GOARCH=amd64 make release-client
GOOS=windows GOARCH=386 make release-client
GOOS=windows GOARCH=amd64 make release-client
GOOS=darwin GOARCH=386 make release-client
GOOS=darwin GOARCH=amd64 make release-client
GOOS=linux GOARCH=arm make release-client

cp -r /ngrok/bin ${MY_FILES}/bin

# create client cfg
echo "server_addr: ${DOMAIN}${TUNNEL_ADDR}" > ${MY_FILES}/ngrok.cfg
echo "trust_host_root_certs: false" >> ${MY_FILES}/ngrok.cfg
echo "tunnels:" >> ${MY_FILES}/ngrok.cfg
echo " ssh:" >> ${MY_FILES}/ngrok.cfg
echo "  proto:" >> ${MY_FILES}/ngrok.cfg
echo "   tcp: 22" >> ${MY_FILES}/ngrok.cfg
echo " shadowsock:" >> ${MY_FILES}/ngrok.cfg
echo "  remote_port: 1088" >> ${MY_FILES}/ngrok.cfg
echo "  proto:" >> ${MY_FILES}/ngrok.cfg
echo "   tcp: 1188" >> ${MY_FILES}/ngrok.cfg
echo " ftp:" >> ${MY_FILES}/ngrok.cfg
echo "  remote_port: 24" >> ${MY_FILES}/ngrok.cfg
echo "  proto:" >> ${MY_FILES}/ngrok.cfg
echo "   tcp: 24" >> ${MY_FILES}/ngrok.cfg
echo " http:" >> ${MY_FILES}/ngrok.cfg
echo "  subdomain: gitlab" >> ${MY_FILES}/ngrok.cfg
echo "  proto:" >> ${MY_FILES}/ngrok.cfg
HTTP_ADDR_TMP=`echo ${HTTP_ADDR} | tr -d ':'`
echo "   http: ${HTTP_ADDR_TMP}" >> ${MY_FILES}/ngrok.cfg
echo "   https: 172.3.2.1${HTTPS_ADDR}" >> ${MY_FILES}/ngrok.cfg


echo "build ok !"
