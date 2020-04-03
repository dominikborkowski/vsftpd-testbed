# VSFTPD Testbed

This is a basic Alpine Linux based container running VSFTPD, with a number of pre-populated users & passwords. Various settings can be changed at run time.


## Overview

* Alpine Linux 3.10
* VSFTPD 3.0.3
* Local users & passwords configured via plain text input file
* Setup, user list, server config, and server logs directed to stdout
* Small size: 8.7MB


## Usage

```
docker-compose up
```

## Configuration

Environment variables:

* `VSFTPD_ANONYMOUS_ACCESS`
	* Enable anonymous access
	* Default: `true`
* `VSFTPD_CHROOT_LOCAL_USER`: 
	* Chroot local users
	* Default: `true`
* `VSFTPD_HIDE_IDS`
	* Hide user IDs, show files owned by ftp:ftp
	* Default: `false`
* `VSFTPD_MIN_PORT`
	* Low port for passive connection range
	* Default: `21000`
* `VSFTPD_MAX_PORT`
	* High port for passive connection range
	* Default: `21099`
* `VSFTPD_UPLOADED_FILES_WORLD_READABLE`
	* Set uploaded files to be world readable
	* Default: `true`
* `VSFTPD_USERS_FILE`
	* CSV of users & passwords for local ftp accounts
	* Default: `/vsftpd-users.csv`


## `VSFTPD_USERS_FILE`

Syntax:
```
username1,password1
username2,password2
```

## Sample output

```
vsftpd    | [CR VSFTPD 17:03:04] Starting setup for VSFTPD:
vsftpd    | [CR VSFTPD 17:03:04]  Enabled access for anonymous user
vsftpd    | [CR VSFTPD 17:03:04]  Confine local users to chroot, they won't be able to see entire filesystem
vsftpd    | [CR VSFTPD 17:03:04]  Uploaded files will become world readable
vsftpd    | [CR VSFTPD 17:03:04] User: alice, password: 123456
vsftpd    | [CR VSFTPD 17:03:04] executing: useradd -m -p $6$hpk.ynpvTCWSTZEr$2oWC5j8K9jKgQJsFdp9dLQWn3rgG2H5/bzWGVbF7MXcyn9POEKDs92NvY1/WZka6FPqt5vvAMqABF5zfcQtyW0 alice
vsftpd    | [CR VSFTPD 17:03:04] User: bob, password: 123456789
vsftpd    | [CR VSFTPD 17:03:04] executing: useradd -m -p $6$FrRwK8jnBtVQnxdf$IQ8GaAtIMlGHNN7GNbHb7MkgonTSlGsJ.VuwHhqKXyVJfAVP/vdMn5IamMiIrZ0AvR1.6.79rdl9KUyUTIMlj1 bob
[...]
vsftpd    | [CR VSFTPD 17:03:05] User: wendy, password: princess
vsftpd    | [CR VSFTPD 17:03:05] executing: useradd -m -p $6$P3c/4wPCLDFYpPOO$DM8wy24F78YHYRSfROcBzJaAGWMAIxY79H.JEONtCArJxYYbKUXrwWTOeBXG0z7NOH1AbKD3.c9d0qbLPtPxY0 wendy
vsftpd    |     SERVER SETTINGS
vsftpd    | 	---------------
vsftpd    | 	· seccomp_sandbox=NO
vsftpd    | 	· background=NO
vsftpd    | 	· anonymous_enable=YES
vsftpd    | 	· anon_root=/var/lib/ftp
vsftpd    | 	· local_enable=YES
vsftpd    | 	· write_enable=YES
vsftpd    | 	· local_umask=022
vsftpd    | 	· chroot_local_user=YES
vsftpd    | 	· allow_writeable_chroot=YES
vsftpd    | 	· hide_ids=NO
vsftpd    | 	· text_userdb_names=YES
vsftpd    | 	· tilde_user_enable=YES
vsftpd    | 	· dirmessage_enable=YES
vsftpd    | 	· ftpd_banner=Welcome to Cyber Range FTP server
vsftpd    | 	· port_enable=YES
vsftpd    | 	· connect_from_port_20=YES
vsftpd    | 	· ftp_data_port=20
vsftpd    | 	· pasv_enable=YES
vsftpd    | 	· log_ftp_protocol=YES
vsftpd    | 	· xferlog_enable=YES
vsftpd    | 	· xferlog_file=/var/log/vsftpd/vsftpd.log
vsftpd    | 	· vsftpd_log_file=/proc/1/fd/1
vsftpd    | chown: /var/lib/ftp/welcome.tx: No such file or directory
vsftpd    | [CR VSFTPD 17:03:05] Starting VSFTPD daemon with:
vsftpd    | [CR VSFTPD 17:03:05]  /usr/sbin/vsftpd -opasv_min_port=21000 -opasv_max_port=21099 /etc/vsftpd/vsftpd.conf
```