FROM alpine:3.5
ENV CONFIG_JSON={ "log": { "loglevel": "warning" }, "inbound": { "protocol": "vmess", "port": 8080, "settings": { "clients": [ { "id": "030479e2-ebe4-4094-92eb-51d5f2eb6586", "alterId": 64, "security": "aes-128-gcm" } ] }, "streamSettings": { "network": "ws" } }, "inboundDetour": [], "outbound": { "protocol": "freedom", "settings": {} } }
RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 #&& curl -L -H "Cache-Control: no-cache" -o /v2ray.zip https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip \
 && curl -L -H "Cache-Control: no-cache" -o /v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/v4.31.0/v2ray-linux-64.zip \
 && mkdir /usr/bin/v2ray /etc/v2ray \
 && touch /etc/v2ray/config.json \
 && unzip /v2ray.zip -d /usr/bin/v2ray \
 && rm -rf /v2ray.zip /usr/bin/v2ray/*.sig /usr/bin/v2ray/doc /usr/bin/v2ray/*.json /usr/bin/v2ray/*.dat /usr/bin/v2ray/sys* \
 && chgrp -R 0 /etc/v2ray \
 && chmod -R g+rwX /etc/v2ray
ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
ENTRYPOINT ["/bin/sh", "-c", "/configure.sh"]
EXPOSE 8080
