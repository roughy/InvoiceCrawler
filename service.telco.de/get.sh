#!/bin/sh

# constants
NAME_SERVICE="telco"
PATH_ROOT="$PATH_SERVICE/.."

# Login data
DATA_ACTION="https://service.telco.de/frei/LOGIN"
DATA_DESTINATION="/telco/index3.php"

# Download Data
DATA_IDCOLLECTION_URL="https://service.telco.de/telco/rechnungonline.php"
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
	readBackupPath

	# save config
	echo "# comment
$save_id
$save_username
$save_password
$save_bkpPath
" > $PATH_CONFIG/$FILE_CONFIG
	
	logIntoApp
	parseAvailableIDs
	getFiles
	backupFiles
}

logIntoApp() {
	if [ ! -f $FILE_COOKIE ]; then
		$BIN_CURL \
			-c $FILE_COOKIE \
			--user-agent "$DATA_USERAGENT" \
			-F "credential_0=$username" \
			-F "credential_1=$password" \
			-F "destination=$DATA_DESTINATION" \
			$DATA_ACTION
	fi	
}

parseAvailableIDs() {
	data=`$BIN_CURL \
		-b $FILE_COOKIE \
		--user-agent "$DATA_USERAGENT" \
		$DATA_IDCOLLECTION_URL\?action=rechnungonline\&unteraction=$DATA_UNTERACTION\&rechsehen=Alle\+Rechnungen\+anzeigen | \
		$BIN_GREP "option value" | \
		$BIN_SED -e 's/<select name=datum>//' -e 's/<option value=\"//' -e 's/\([0-9]*\)\">\([0-9\.]*\)<.*/\1;\2;/'`

	counter=1
	countID=0
	countDate=0
	switcher="1"
	while [ 1 ]; do
		item=`echo $data | cut -f $counter-$counter -d \;`
		if [ "$item" = "" ]; then
			break
		fi

		if [ "$switcher" = "1" ]; then
			idData[$countID]=$item
			countID=`expr $countID + 1`
			switcher="2"
		else
			dateData[$countDate]=$item
			countDate=`expr $countDate + 1`
			switcher="1"
		fi

		counter=`expr $counter + 1`
	done
}

downloadFile() {
	dateId=$1
	dlFile=$2
	
	$BIN_CURL \
		-b $FILE_COOKIE \
		--user-agent "$DATA_USERAGENT" \
		-o $dlFile \
		$DATA_DOWNLOAD_URL\?dt=$DATA_DOCTYPE\&datum=$dateId\&unterunteraction=ConvertDoc	
}

getFiles() {
	counter=0

	for date in ${dateData[@]}; do
		id=${idData[$counter]}

		file="$PATH_CACHE/$date-$FILE_APPENDIX"				
		if [ -f $file ]; then
			echo "found file ($id) $date-$FILE_APPENDIX"
			echo "skip download"
		else
			echo "download file ($id) $date-$FILE_APPENDIX"	
			downloadFile $id $file		
			if [ -f $file ]; then
				echo "$TEXT_DLD_SUCCESS ($date-$FILE_APPENDIX)"
			else
				echo "$TEXT_DLD_NONE ($date-$FILE_APPENDIX)"
				break	
			fi
		fi

		counter=`expr $counter + 1`
	done
}

backupFiles() {
	echo "backup?"
	read backup
	backup="$(echo ${backup} | tr 'A-Z' 'a-z')" # to lower
	echo 

	if [ $backup = "y" ]; then
		checkZip
		cd $PATH_CACHE
		$BIN_ZIP $bkpPath/$NAME_SERVICE.zip ./*.*
		cd - > /dev/null
	fi
}