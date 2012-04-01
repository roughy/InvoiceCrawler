#!/bin/sh

# constants
PATH_SERVICE="`pwd`/`dirname ${0}`"
FILE_APPENDIX=".pdf"
FILE_CONFIG="vattenfall.conf"
NAME_SERVICE="vattenfall"
PATH_ROOT="$PATH_SERVICE/.."

# Host
DATA_HOST="https://kundenservice.vattenfall.de"

# Login data
DATA_ACTION="$DATA_HOST/kundenservice-online/Login.action"

# Download Data
DATA_LINKCOLLECTION_URL="$DATA_HOST/kundenservice-online/MenuRightsController.action?showMenuInvoice=&mainNav=menuInvoice"

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
$save_username
$save_password
$save_bkpPath
" > $PATH_CONFIG/$FILE_CONFIG

# functions
logIntoApp() {
	if [ ! -f $FILE_COOKIE ]; then
		$BIN_CURL \
			-c $FILE_COOKIE \
			--user-agent "$DATA_USERAGENT" \
			-F "targetPage=" \
			-F "loginId=$username" \
			-F "password=$password" \
			-F "login=Log-In" \
			$DATA_ACTION > /dev/null
	fi	
}

parseAvailableLinks() {
	linkData=`$BIN_CURL \
		-b $FILE_COOKIE \
		--user-agent "$DATA_USERAGENT" \
		$DATA_LINKCOLLECTION_URL | \
		$BIN_GREP "<a href=\"/kundenservice-online/Rechnungeneinsehen.action" | \
		$BIN_SED -n -e 's/\(^.*<a href="\)\([^"]*pdf\)\(".*$\)/\2/gp'`

	dateData=`$BIN_CURL \
		-b $FILE_COOKIE \
		--user-agent "$DATA_USERAGENT" \
		$DATA_LINKCOLLECTION_URL | \
		$BIN_GREP "[[:digit:]]\{2\}\.[[:digit:]]\{2\}\.[[:digit:]]\{4\}[[:space:]](pdf)" | \
		$BIN_SED -e 's/\(^.*\)\([0-9]\{2\}\.[0-9]\{2\}\.[0-9]\{4\}\)\(.*$\)/\2/'`
}

downloadFile() {
	uri=$1
	dlFile=$2
	
	$BIN_CURL \
		-b $FILE_COOKIE \
		--user-agent "$DATA_USERAGENT" \
		-o $dlFile \
		$DATA_HOST$uri
}

getFiles() {
	counter=0

	for date in ${dateData[@]}; do
		file="$PATH_CACHE/$date$FILE_APPENDIX"				
		if [ -f $file ]; then
			echo "found file $date$FILE_APPENDIX"
			echo "skip download"
		else
			linkCounter=0
			for link in ${linkData[@]}; do
				if [ $counter = $linkCounter ]; then
					break;
				fi
				linkCounter=`expr $linkCounter + 1`
			done
			
			downloadFile $link $file		
			if [ -f $file ]; then
				echo "$TEXT_DLD_SUCCESS ($date$FILE_APPENDIX)"
			else
				echo "$TEXT_DLD_NONE ($date$FILE_APPENDIX)"
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

# run crawler
logIntoApp
parseAvailableLinks
getFiles
backupFiles