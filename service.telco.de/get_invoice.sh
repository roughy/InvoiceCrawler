#!/bin/sh

# constants
PATH_SERVICE="`pwd`/`dirname ${0}`"
FILE_APPENDIX="invoice.pdf"
FILE_CONFIG="invoice.telco.conf"
DATA_DOCTYPE="RECH"
DATA_UNTERACTION="rechnung24"

# include base
. $PATH_SERVICE/get.sh
runCrawler
