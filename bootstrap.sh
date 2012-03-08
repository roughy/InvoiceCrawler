#!/bin/sh

# include files
. $PATH_ROOT/include/constants.sh
. $PATH_ROOT/lib/readInput.sh
. $PATH_ROOT/lib/config.sh

bootstrap() {
	# read config
	readConfig $FILE_CONFIG

	# read input
	readParameter $*
	readUsername
	readPassword

	# save config
	echo "# comment
$save_username
$save_password
" > $PATH_CONFIG/$FILE_CONFIG	
}
