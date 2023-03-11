FROM alpine:3.17

# renovate: datasource=pypi depName=ansible
ARG ANSIBLE_VERSION="7.3.0"

RUN \
 echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
 apk update && \
 apk add bash dmidecode hwinfo kexec-tools lshw py3-jmespath py3-pip usbutils unzip wget && \
 rm -vrf /var/cache/apk/* && \
 pip install --no-cache-dir --upgrade pip && \
 pip install --no-cache-dir ansible==${ANSIBLE_VERSION}
 
COPY . /opt/core

RUN \
 wget https://raw.githubusercontent.com/netbootxyz/netboot.xyz/master/roles/netbootxyz/defaults/main.yml -O /opt/core/releases.yml && \
 wget https://raw.githubusercontent.com/netbootxyz/netboot.xyz/master/endpoints.yml -O /opt/core/endpoints.yml

ENTRYPOINT ["/opt/core/load.sh"]
