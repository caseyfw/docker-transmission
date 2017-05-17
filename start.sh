#!/bin/sh

# Create directories for transmission downloads and config.
mkdir -p ${DOWNLOAD_DIR:="/downloads"} \
    ${INCOMPLETE_DIR:="/downloads/incomplete"} \
    ${CONFIG_DIR:="/etc/transmission"}

# If container is invoked with a specific UID, create a user with that id.
if [ "${UID:=0}" != 0 ]; then
    chown -R ${UID}:${UID} /downloads
    chown -R ${UID}:${UID} /etc/transmission
    adduser -D -u ${UID} user
    run="sudo -E -u user"
fi

# Run the transmission daemon, either as root or the requested user id.
${run:-"exec"} transmission-daemon -f \
    --allowed=${ALLOWED:-"*"} \
    --download-dir=${DOWNLOAD_DIR} \
    --incomplete-dir=${INCOMPLETE_DIR} \
    --peerport=${PORT:-"6881"} \
    --port=${WEB_PORT:-"9091"} \
    --auth \
    --username="${USERNAME:-"username"}" \
    --password="${PASSWORD:-"password"}" \
    --config-dir /etc/transmission
