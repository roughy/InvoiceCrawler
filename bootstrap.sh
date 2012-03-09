#!/bin/sh

# include files
. $PATH_ROOT/include/constants.sh
. $PATH_ROOT/lib/readInput.sh
. $PATH_ROOT/lib/config.sh
. $PATH_ROOT/lib/checkbin.sh

bootstrap() {
	# read config
	readConfig $FILE_CONFIG

	# read input
	readParameter $*
}
