# VSFTPD Testbed

This is a basic Alpine Linux based container running VSFTPD, with a number of pre-populated users & passwords. Various settings can be changed at run time.


## Overview

* Alpine Linux 3.10
* VSFTPD 3.0.3
* Local users & passwords configured via plain text input file
* Setup, user list, server config, and server logs directed to stdout
* Ability to specify content of `~/flag.txt` for a given user

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
username2,password2,content_of_optional_flag.txt
```

## Sample output

```
Creating network "vsftpd-testbed_vsftpd-network" with the default driver
Creating vsftpd ... done
Attaching to vsftpd
vsftpd    | [CR VSFTPD 13:10:04] Starting setup for VSFTPD:
vsftpd    | [CR VSFTPD 13:10:04]  Enabled access for anonymous user
vsftpd    | [CR VSFTPD 13:10:04]  Confine local users to chroot, they won't be able to see entire filesystem
vsftpd    | [CR VSFTPD 13:10:04]  Uploaded files will become world readable
vsftpd    | [CR VSFTPD 13:10:04] User: alice, password: 123456, flag: 3144e4b96f7fd15227332e23b8537d89
vsftpd    | [CR VSFTPD 13:10:04]  Executing: useradd -m -p $6$bAFDKO1H6i0AEWGR$XAbz4AwecbeCLAH.dF7id4jeCvO/4c2SNb0hgf9ACO8BCA1wVBjzjBAv7gorfOFCfcDQQV15NAnb81TjnpM/30 alice
vsftpd    | [CR VSFTPD 13:10:04]  Creating ~alice/flag.txt with following content: 3144e4b96f7fd15227332e23b8537d89
vsftpd    | [CR VSFTPD 13:10:04] User: bob, password: 123456789, flag: 95fbdaa0f180b28b7eed1d5635015b6ddda10355
vsftpd    | [CR VSFTPD 13:10:04]  Executing: useradd -m -p $6$AnFknBia810UMlSD$bFfmOUDVZoCGHJ9r.XnbxUcQnNc5OspyjUQwARk1zlu7QpkLDDOIImRMcZzLR/eMvtECiZ7fiJJcpRMxrC8Sk/ bob
vsftpd    | [CR VSFTPD 13:10:04]  Creating ~bob/flag.txt with following content: 95fbdaa0f180b28b7eed1d5635015b6ddda10355
vsftpd    | [CR VSFTPD 13:10:04] User: carol, password: qwerty, flag:
vsftpd    | [CR VSFTPD 13:10:04]  Executing: useradd -m -p $6$/W1SPJZHaU0V/B.d$HQSyLXSvt4/ojObnYKKKEkhKjbGYqQTowZS4UzDp8pAKwbzULOHMonmnphFiCbX6UxHmKFpGz43vtwPMZu9ez. carol
vsftpd    | [CR VSFTPD 13:10:04] NO FLAG
[...]
vsftpd    | [CR VSFTPD 13:10:05] User: wendy, password: princess, flag:
vsftpd    | [CR VSFTPD 13:10:05]  Executing: useradd -m -p $6$2ncM9uCCCo//bJNZ$dTlpLjUO3ngolOd8KDYTjYbhr2/eC1RlAY1QM/cPkXIhrWQP2lcgyTbfh1ZOe8GguY0TvKdCKBKHIaChL7Sga/ wendy
vsftpd    | [CR VSFTPD 13:10:05] NO FLAG
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
vsftpd    | 	· text_userdb_names=YES
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
vsftpd    | [CR VSFTPD 13:10:05] Creating text file with a welcome message
vsftpd    | [CR VSFTPD 13:10:05] Starting VSFTPD daemon with:
vsftpd    | [CR VSFTPD 13:10:05]  /usr/sbin/vsftpd -opasv_min_port=21000 -opasv_max_port=21099 /etc/vsftpd/vsftpd.conf
```