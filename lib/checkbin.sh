#!/bin/sh
BIN_CURL=`which curl`

checkCurl() {
	if [ ! -f $BIN_CURL ]; then
		echo $TEXT_NO_CURL \"$BIN_CURL\"
		exit 1
	elif [ ! -x $BIN_CURL ]; then
		echo $TEXT_NOEXEC_CURL \"$BIN_CURL\"
		exit 1
	fi
}