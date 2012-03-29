#!/bin/sh
BIN_CURL=`which curl`
BIN_ZIP=`which zip`
BIN_GREP=`which grep`
BIN_SED=`which sed`
BIN_SORT=`which sort`
BIN_MD5=`which md5`

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