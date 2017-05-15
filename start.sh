#!/bin/sh

# Create directories for transmission downloads and config.
mkdir -p ${DOWNLOAD_DIR:="/downloads"} ${INCOMPLETE_DIR:="/downloads/incomplete"} /etc/transmission-daemon

# If container is invoked with a specific UID, create a user with that id.
if [ "${UID:=0}" != 0 ]; then
    chown -R ${UID}:${UID} /downloads
    chown -R ${UID}:${UID} /etc/transmission
    adduser -D -u ${UID} user
    run="sudo -E -u user"
fi

${run:="exec"} transmission-daemon -f \
    --allowed=${ALLOWED:="*"} \
    --download-dir=${DOWNLOAD_DIR} \
    --incomplete-dir=${INCOMPLETE_DIR} \
    --peerport=${PORT:="6881"} \
    --port=${WEB_PORT:="9091"} \
    --auth \
    --username="${USERNAME:="username"}" \
    --password="${PASSWORD:="password"}" \
    --config-dir /etc/transmission
