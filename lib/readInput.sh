#!/bin/sh

# config vars
input_username=
input_password=
username=
password=
save_username=
save_password=

# read input parameter
readParameter() {
	if [ "$1" = "-?" ]; then
		echo $TEXT_HELP
		exit 1
	elif [ "$1" = "--help" ]; then
		echo $TEXT_HELP
		exit 1
	fi

	while getopts hp:u: option
	do	case "$option" in
		u)	input_username="$OPTARG";;
		p)	input_password="$OPTARG";;
		h)	echo $TEXT_HELP
			exit 1;;
		esac
	done	
}

# read username if not given as parameter
readUsername() {
	if [ $input_username ]; then
		# save previous username
		save_username="username=$username"

		username=$input_username
	elif [ ! $username ]; then
		echo "name?"
		read username
		save_username="username=$username"
	else
		save_username="username=$username"
	fi
}

# read password if not given as parameter
readPassword() {
	if [ $input_password ]; then
		# save previous pw
		save_password="password=$password"

		password=$input_password
	elif [ ! $password ]; then
		echo "pw?"
		read password

		echo "save?"
		read save_password

		save_password="$(echo ${save_password} | tr 'A-Z' 'a-z')"
		if [ "$save_password" = "y" ]; then
			save_password="password=$password"
		else
			save_password=
		fi
	else
		save_password="password=$password"
	fi
}