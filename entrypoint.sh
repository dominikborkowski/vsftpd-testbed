#!/bin/sh
# Start VSFTPD service

# Write nicely formatted log lines
log() { if [[ "$@" ]]; then echo "[CR VSFTPD $(date +'%T')] $@"; else echo; fi }

# Prepend lines with something
prepend() { while read line; do echo "${1}${line}"; done; }

log "Starting setup for VSFTPD: "

if [ "${VSFTPD_ANONYMOUS_ACCESS}" = "true" ]; then
    sed -i "/^anonymous_enable/s/NO/YES/" /etc/vsftpd/vsftpd.conf && \
    log " Enabled access for anonymous user"
fi

# # Uploaded files world readable settings
if [ "${VSFTPD_UPLOADED_FILES_WORLD_READABLE}" = "true" ]; then
    sed -i "/^local_umask/s/077/022/" /etc/vsftpd/vsftpd.conf && \
    log " Uploaded files will become world readable"
fi

# Print out basic info on stdout
cat <<EOB
    USER SETTINGS
	---------------
EOB

if [ -f ${VSFTPD_USERS_FILE} ]; then
    while IFS="," read -r user password ; do
        log "User: $user, password: $password"
        log "executing: useradd -m -p $(mkpasswd "$password") $user"
        useradd -m -p $(mkpasswd "$password") $user
    done < ${VSFTPD_USERS_FILE}
else
    log "User file not provided, skipping user creation"
fi


# Create home dir and update vsftpd user db:
# mkdir -p "/home/vsftpd/${VSFTPD_FTP_USER}" && \
#     log " Created home directory for user: ${VSFTPD_FTP_USER}"

# echo -e "${VSFTPD_FTP_USER}\n${VSFTPD_FTP_PASS}" > /etc/vsftpd/virtual_users.txt && \
#     log " Updated /etc/vsftpd/virtual_users.txt"

# /usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db && \
#     log " Updated vsftpd user database"

# chmod 600 /etc/vsftpd/virtual_users.db && \
#     log " Set permissions on vsftpd user database"

# Get log file path
export VSFTPD_LOG_FILE=$(awk -F '=' '/^vsftpd_log_file/ {print $2}' /etc/vsftpd/vsftpd.conf)


cat <<EOB
    SERVER SETTINGS
	---------------
EOB

# Print all other vsftpd settings
egrep -v '^#|^$' /etc/vsftpd/vsftpd.conf | prepend "	· "

# Touch basic file in the root for anonymous user
echo "Welcome to Cyber Range FTP Server" > /var/lib/ftp/welcome.txt && \
    log "Creating text file with a welcome message"

# Run vsftpd:
log "Starting VSFTPD daemon with:"
log " /usr/sbin/vsftpd -opasv_min_port=$VSFTPD_MIN_PORT -opasv_max_port=$VSFTPD_MAX_PORT /etc/vsftpd/vsftpd.conf"
/usr/sbin/vsftpd -opasv_min_port=$VSFTPD_MIN_PORT -opasv_max_port=$VSFTPD_MAX_PORT /etc/vsftpd/vsftpd.conf
