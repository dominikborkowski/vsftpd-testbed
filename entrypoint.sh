#!/bin/sh
# Start VSFTPD service

# Write nicely formatted log lines
log() { if [[ "$@" ]]; then echo "[CR VSFTPD $(date +'%T')] $@"; else echo; fi; }

# Prepend lines with something
prepend() { while read line; do echo "${1}${line}"; done; }

log "Starting setup for VSFTPD: "

# Anonymous access
if [ "${VSFTPD_ANONYMOUS_ACCESS}" = "true" ]; then
    sed -i "/^anonymous_enable/s/NO/YES/" /etc/vsftpd/vsftpd.conf &&
        log " Enabled access for anonymous user"
fi

# Chroot local users
if [ "${VSFTPD_CHROOT_LOCAL_USER}" = "true" ]; then
    sed -i "/^chroot_local_user/s/NO/YES/" /etc/vsftpd/vsftpd.conf &&
        log " Confine local users to chroot, they won't be able to see entire filesystem"
fi

# Hide user IDs
if [ "${VSFTPD_HIDE_IDS}" = "true" ]; then
    sed -i "/^hide_ids/s/NO/YES/" /etc/vsftpd/vsftpd.conf &&
        log " Enabled hiding user IDs, files will appear owned as ftp:ftp"
fi

# Uploaded files world readable settings
if [ "${VSFTPD_UPLOADED_FILES_WORLD_READABLE}" = "true" ]; then
    sed -i "/^local_umask/s/077/022/" /etc/vsftpd/vsftpd.conf &&
        log " Uploaded files will become world readable"
fi

# Add users from a CSV file
if [ -f ${VSFTPD_USERS_FILE} ]; then
    # Protect the file, just in case if a user explores the filesystem
    chmod 600 ${VSFTPD_USERS_FILE}
    # Read users, passwords, and optional content of a flag file
    while IFS="," read -r user password flag; do
        log "User: $user, password: $password, flag: $flag"
        log " Executing: useradd -m -p $(mkpasswd "$password") $user"
        useradd -m -p $(mkpasswd "$password") $user
        # Create flag file in given user's home dir
        if [ ! -z ${flag} ]; then
            log " Creating ~${user}/flag.txt with following content: ${flag}"
            flag_file=$(eval "echo ~$user")/flag.txt
            echo "${flag}" >${flag_file}
            chown ${user}:${user} ${flag_file}
            chmod 600 ${flag_file}
        else
            log "NO FLAG"
        fi
    done <${VSFTPD_USERS_FILE}
else
    log "User file not provided, skipping user creation"
fi

# Get log file path
export VSFTPD_LOG_FILE=$(awk -F '=' '/^vsftpd_log_file/ {print $2}' /etc/vsftpd/vsftpd.conf)

cat <<EOB
    SERVER SETTINGS
	---------------
EOB

# Print all other vsftpd server settings
egrep -v '^#|^$' /etc/vsftpd/vsftpd.conf | prepend "	· "

# Touch basic file in the root for anonymous user
echo "Welcome to Cyber Range FTP Server" >/var/lib/ftp/welcome.txt &&
    chown ftp:ftp /var/lib/ftp/welcome.txt &&
    log "Creating text file with a welcome message"

# Run vsftpd:
log "Starting VSFTPD daemon with:"
log " /usr/sbin/vsftpd -opasv_min_port=$VSFTPD_MIN_PORT -opasv_max_port=$VSFTPD_MAX_PORT /etc/vsftpd/vsftpd.conf"
/usr/sbin/vsftpd -opasv_min_port=$VSFTPD_MIN_PORT -opasv_max_port=$VSFTPD_MAX_PORT /etc/vsftpd/vsftpd.conf
