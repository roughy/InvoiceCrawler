#!/bin/sh

# constants
PATH_ROOT="$PATH_SERVICE/.."
PATH_CACHE="$PATH_SERVICE/downloads"
FILE_COOKIE="/tmp/telco_cookie.txt"

# Login data
DATA_ACTION="https://service.telco.de/frei/LOGIN"
DATA_DESTINATION="/telco/index3.php"

# Download Data
DATA_DOWNLOAD_URL="https://service.telco.de/telco/phppdfdrillisch.php"

runCrawler() {
	# bootstrap
	. $PATH_ROOT/bootstrap.sh
	bootstrap
	
	# check prerequisites
	checkCurl

	# read neccessary data
	readUsername
	readPassword
	readId

	# save config
	echo "# comment
$save_id
$save_username
$save_password
" > $PATH_CONFIG/$FILE_CONFIG
	
	getFiles
}

loginAndDownload() {
	dateId=$1
	dlFile=$2
	
	if [ ! -f $FILE_COOKIE ]; then
		$BIN_CURL \
			-c $FILE_COOKIE \
			--user-agent "$DATA_USERAGENT" \
			-F "credential_0=$username" \
			-F "credential_1=$password" \
			-F "destination=$DATA_DESTINATION" \
			$DATA_ACTION
	fi

	$BIN_CURL \
		-b $FILE_COOKIE \
		--user-agent "$DATA_USERAGENT" \
		-o $dlFile \
		$DATA_DOWNLOAD_URL\?dt=$DATA_DOCTYPE\&datum=$dateId\&unterunteraction=ConvertDoc	
}

getFiles() {
	curID=$id
	while [ $curID -gt 0 ]; do
		file="$PATH_CACHE/$curID.$FILE_APPENDIX"
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
}
