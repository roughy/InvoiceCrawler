#!bin/sh

# constants

# texts
TEXT_HELP="Usage: $0 [-u username] [-p password] [-h]"
TEXT_NO_CURL="Can't find curl at"
TEXT_NOEXEC_CURL="Can't execute curl at"
TEXT_NO_ZIP="Can't find zip at"
TEXT_NOEXEC_ZIP="Can't execute zip at"
TEXT_DLD_SUCCESS="File downloaded"
TEXT_DLD_NONE="No file downloaded"
TEXT_NO_DIR="Directory doesn't exist"
TEXT_NO_WRITEABLE_DIR="Directory has no write permission"

# files & paths
PATH_CONFIG="$PATH_ROOT/.config"
PATH_CACHE="$PATH_SERVICE/downloads"
FILE_COOKIE="/tmp/$NAME_SERVICE.cookie.txt"

# stuff
DATA_USERAGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0.1) Gecko/20100101 Firefox/8.0.1"
TTL_COOKIE=60 # sec
