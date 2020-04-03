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
