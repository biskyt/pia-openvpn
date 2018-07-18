FROM alpine:latest
MAINTAINER biskyt

RUN apk -U upgrade && \
    apk add --no-cache openvpn curl bash jq && \
    #
    #AES256 encryption profiles
    curl -o /openvpn-strong.zip https://www.privateinternetaccess.com/openvpn/openvpn-strong.zip && \
    mkdir /etc/openvpn/pia-strong && \
    unzip -d /etc/openvpn/pia-strong/ /openvpn-strong.zip && \
    #AES128 encryption profiles
    curl -o /openvpn.zip https://www.privateinternetaccess.com/openvpn/openvpn.zip && \
    mkdir /etc/openvpn/pia-standard && \
    unzip -d /etc/openvpn/pia-standard/ /openvpn.zip && \
    #
    # cleanup temporary files
    rm -rf /tmp/* && \
    rm /openvpn.zip && \
    rm /openvpn-strong.zip && \
    rm -rf /var/cache/apk/* && \
    mkdir /portforward && \
    touch /portforward/port.txt && \
    chmod -R 777 /portforward
    #echo net.ipv4.ip_forward=1 > /etc/sysctl.d/10-port-forward.conf


COPY openvpn.sh /usr/local/bin/openvpn.sh
COPY up.sh /etc/openvpn
COPY up2.sh /etc/openvpn
COPY pia_portforward.sh /etc/openvpn
COPY down.sh /etc/openvpn
COPY port-refresh.sh /etc/openvpn
COPY cron.hourly/* /etc/periodic/hourly/
RUN chmod a+rx /etc/openvpn/*.sh && chmod -R a+rx /etc/periodic/hourly/

WORKDIR /etc/openvpn

ENV REGION="France"

HEALTHCHECK --interval=60s --timeout=15s --start-period=120s \
    CMD curl -L 'https://api.ipify.org'

VOLUME /portforward

EXPOSE 9091 8989 7878 9117 5050

ENTRYPOINT ["openvpn.sh"]
