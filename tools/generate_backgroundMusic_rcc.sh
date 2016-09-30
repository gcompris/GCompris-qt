#!/bin/bash
#
# generate_backgroundMusic_rcc.sh
#
# Copyright (C) 2016 Divyam Madaan
#
# Generates Qt binary resource files (.rcc) for background music.
#
# Results will be written to $PWD/.rcc/ which is supposed be synced to the
# upstream location.
#

[ $# -ne 2 ] && {
    echo "Usage: generate_backgroundMusic_rcc.sh ogg|aac|ac3|mp3  <path to bakground music dir>"
    exit 1
}
# Compressed Audio Format
CA=$1

QRC_DIR="."
RCC_DIR=".rcc"
#RCC_DEFAULT=`which rcc 2>/dev/null`   # default, better take /usr/bin/rcc?
RCC_DEFAULT=$Qt5_DIR/bin/rcc
CONTENTS_FILE=Contents
MD5SUM=/usr/bin/md5sum

[ -z "${RCC}" ] && RCC=${RCC_DEFAULT}

[ -z "${RCC}" ] && {
    echo "No rcc command in PATH, can't continue. Try to set specify RCC in environment:"
    echo "RCC=/path/to/qt/bin/rcc $0"
    exit 1
}

MUSIC_DIR=$2
[ ! -d "${MUSIC_DIR}" ] && {
    echo "Words dir ${MUSIC_DIR} not found"
    exit 1
}
[ -d music ] && rm -rf music
ln -s ${MUSIC_DIR} music

function generate_rcc {
    # Generate RCC 
    echo -n "$2 ... "
    mkdir -p ${2%/*}
    ${RCC} -binary $1 -o $2

    echo "md5sum ... "
    cd ${2%/*}
    ${MD5SUM}  ${2##*/}>> ${CONTENTS_FILE}
    cd - &>/dev/null
}

function header_rcc {
(cat <<EOHEADER
<!DOCTYPE RCC><RCC version="1.0">
<qresource prefix="/gcompris/data">
EOHEADER
) > $1
}

function footer_rcc {
(cat <<EOFOOTER
</qresource>
</RCC>
EOFOOTER
) >> $1
}

echo "Generating binary resource files in ${RCC_DIR}/ folder:"

[ -d ${RCC_DIR} ] && rm -rf ${RCC_DIR}
mkdir  ${RCC_DIR}

#header of the global qrc (all the langs)
QRC_FULL_FILE="${QRC_DIR}/backgroundMusic-${CA}.qrc"
RCC_FULL_FILE="${RCC_DIR}/backgroundMusic-${CA}.rcc"
header_rcc $QRC_FULL_FILE

for i in `find ${MUSIC_DIR} -type f -name "*" | sort | cut -c 1-`
do
	echo "    <file>${i#${MUSIC_DIR}}</file>" >> "${QRC_DIR}/backgroundMusic-${CA}.qrc"
done
footer_rcc $QRC_FULL_FILE
echo -n "  full: ${QRC_FULL_FILE} ... "
generate_rcc ${QRC_FULL_FILE} ${RCC_FULL_FILE}

echo "Finished!"
echo ""

#EOF


