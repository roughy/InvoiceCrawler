#!/bin/sh

BIN_CURL=`which curl`

FILE_COOKIE="/tmp/telco_cookie.txt"
FILE_APPENDIX="egn.pdf"
DIR_INVOICE=`pwd`/downloads

# General
DATA_STARTID=2518199
DATA_USERAGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0.1) Gecko/20100101 Firefox/8.0.1"

# Login data
DATA_ACTION="https://service.telco.de/frei/LOGIN"
DATA_LOGIN="[__your login__]"
DATA_PASSWORD="[__your password__]"
DATA_DESTINATION="/telco/index3.php"

# Download Data
DATA_DOWNLOAD_URL="https://service.telco.de/telco/phppdfdrillisch.php"

loginAndDownload() {
	dateId=$1
	dlFile=$2
	
	if [ ! -f $FILE_COOKIE ]; then
		$BIN_CURL \
			-c $FILE_COOKIE \
			--user-agent "$DATA_USERAGENT" \
			-F "credential_0=$DATA_LOGIN" \
			-F "credential_1=$DATA_PASSWORD" \
			-F "destination=$DATA_DESTINATION" \
			$DATA_ACTION
	fi

	$BIN_CURL \
		-b $FILE_COOKIE \
		--user-agent "$DATA_USERAGENT" \
		-o $dlFile \
		$DATA_DOWNLOAD_URL\?dt=EGN\&datum=$dateId\&unterunteraction=ConvertDoc	
}

curID=$DATA_STARTID
while [ $curID -gt 0 ]; do
	file="$DIR_INVOICE/$curID.$FILE_APPENDIX"
	if [ -f $file ]; then
		echo "found file for id $curID"
		curID=`expr $curID - 1`
		continue
	else
		echo "download file with id $curID"
		loginAndDownload $curID $file
		break
	fi
done
