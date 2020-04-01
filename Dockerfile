FROM alpine:3.10
RUN apk --no-cache add vsftpd db db-utils

ENV \
    VSFTPD_ANONYMOUS_ACCESS=true \
    VSFTPD_FTP_USER=admin \
    VSFTPD_FTP_PASS=random \
    VSFTPD_MIN_PORT=21000 \
    VSFTPD_MAX_PORT=21099 \
    VSFTPD_UPLOADED_FILES_WORLD_READABLE=false

COPY entrypoint.sh /entrypoint.sh
COPY container/ /

EXPOSE 20-21 21000-21099
VOLUME /ftp/ftp

ENTRYPOINT ["/entrypoint.sh"]
