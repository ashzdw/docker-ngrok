# DOCKER NGROK IMAGE

## BUILD IMAGE

```linux
git clone https://github.com/ashzdw/docker-ngrok.git
cd docker-ngrok
docker build -t ashzdw/ngrok .
```

## RUN
* you must mount your folder (E.g `/data/ngrok`) to container `/myfiles`
* if it is the first run, it will generate the binaries file and CA in your floder `/data/ngrok`

```linux
docker run -idt --name ngrok-server --network host\
-v /data/ngrok:/myfiles \
-e DOMAIN='tunnel.ashzdw.cn' ashzdw/ngrok /bin/sh /server.sh
```
