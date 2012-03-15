#!/bin/sh
BIN_CURL=`which curl`
BIN_ZIP=`which zip`

checkCurl() {
	if [ ! -f $BIN_CURL ]; then
		echo $TEXT_NO_CURL \"$BIN_CURL\"
		exit 1
	elif [ ! -x $BIN_CURL ]; then
		echo $TEXT_NOEXEC_CURL \"$BIN_CURL\"
		exit 1
	fi
}

checkZip() {
	if [ ! -f $BIN_ZIP ]; then
		echo $TEXT_NO_ZIP \"$BIN_ZIP\"
		exit 1
	elif [ ! -x $BIN_ZIP ]; then
		echo $TEXT_NOEXEC_ZIP \"$BIN_ZIP\"
		exit 1
	fi
}