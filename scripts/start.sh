#!/bin/bash
echo "---Checking if UID: ${UID} matches user---"
usermod -u ${UID} ${USER}
echo "---Checking if GID: ${GID} matches user---"
usermod -g ${GID} ${USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Checking for optional scripts---"
if [ -f /opt/scripts/user.sh ]; then
	echo "---Found optional script, executing---"
    chmod +x /opt/scripts/user.sh
    /opt/scripts/user.sh
else
	echo "---No optional script found, continuing---"
fi

echo "---Starting...---"
mkdir -p $DATA_DIR/".local/share/DayZ" && mkdir -p $DATA_DIR/".local/share/DayZ - Other Profiles"
chown -R ${UID}:${GID} /opt/scripts
chown -R ${UID}:${GID} ${DATA_DIR}
chown -R ${UID}:${GID} $DATA_DIR/.local
chmod -R 770 ${DATA_DIR}/".local/share/DayZ"
chmod -R 770 ${DATA_DIR}/".local/share/DayZ - Other Profiles"

term_handler() {
	kill -SIGTERM "$killpid"
	wait "$killpid" -f 2>/dev/null
	exit 143;
}

trap 'kill ${!}; term_handler' SIGTERM
su ${USER} -c "/opt/scripts/start-server.sh" &
killpid="$!"
while true
do
	wait $killpid
	exit 0;
done