#!/bin/sh

# constants
PATH_SERVICE="`pwd`/`dirname ${0}`"
FILE_APPENDIX="egn.pdf"
FILE_CONFIG="egn.telco.conf"
DATA_DOCTYPE="EGN"
DATA_UNTERACTION="egn24"

# include base
. $PATH_SERVICE/get.sh
runCrawler
