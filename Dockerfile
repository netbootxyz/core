FROM alpine:3.21

# renovate: datasource=pypi depName=ansible
ARG ANSIBLE_VERSION="11.2.0"

RUN \
 apk update && \
 apk add bash dmidecode hwinfo kexec-tools lshw py3-jmespath py3-pip usbutils unzip wget && \
 rm -vrf /var/cache/apk/* && \
 rm -rf /usr/lib/python3.12/EXTERNALLY-MANAGED && \
 pip install --no-cache-dir --upgrade pip && \
 pip install --no-cache-dir ansible==${ANSIBLE_VERSION}
 
COPY . /opt/core

RUN \
 wget https://raw.githubusercontent.com/netbootxyz/netboot.xyz/master/roles/netbootxyz/defaults/main.yml -O /opt/core/releases.yml && \
 wget https://raw.githubusercontent.com/netbootxyz/netboot.xyz/master/endpoints.yml -O /opt/core/endpoints.yml

ENTRYPOINT ["/opt/core/load.sh"]
