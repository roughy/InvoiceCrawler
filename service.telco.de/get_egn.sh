#!/bin/sh

# constants
PATH_SERVICE="`pwd`/`dirname ${0}`"
FILE_APPENDIX="egn.pdf"
FILE_CONFIG="egn.telco.conf"
DATA_DOCTYPE="EGN"

# include base
. $PATH_SERVICE/get.sh
runCrawler
