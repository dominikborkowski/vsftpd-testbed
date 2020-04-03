FROM alpine:3.10
RUN apk --no-cache add vsftpd shadow && \
    sed -i '/^CREATE_MAIL_SPOOL/s/yes/no/' /etc/default/useradd

# default settings, can be overwritten via docker-compose
ENV \
    VSFTPD_ANONYMOUS_ACCESS=true \
    VSFTPD_CHROOT_LOCAL_USER=true \
    VSFTPD_HIDE_IDS=false \
    VSFTPD_MIN_PORT=21000 \
    VSFTPD_MAX_PORT=21099 \
    VSFTPD_UPLOADED_FILES_WORLD_READABLE=false\
    VSFTPD_USERS_FILE=/vsftpd-users.csv


COPY entrypoint.sh /entrypoint.sh
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

EXPOSE 20-21 21000-21099
VOLUME /ftp/ftp

ENTRYPOINT ["/entrypoint.sh"]
