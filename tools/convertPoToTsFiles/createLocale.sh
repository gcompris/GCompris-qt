#!/bin/bash
#
# This tool is used to create a new translation file with
# all the strings taken from the Gtk+ version of GCompris.
#
locale=$1
gcomprisGtkPoFile=$2

function usage {
  echo "This tool is used to create a new translation file with " \
       "all the strings taken from the Gtk+ version of GCompris"
  echo "Usage: createLocale.sh locale gcomprisGtkPoFile"
}

if [ "$locale" == "" -o "$gcomprisGtkPoFile" == "" ]
then
  usage
  exit 1
fi

currentDir=$(pwd)

echo "Processing $locale"
# Remove some comment that breaks python polib
poSource=$(mktemp posource_XXXXXXXXX)
cat $gcomprisGtkPoFile | grep -v "^#[\.\~]" > $poSource
cp gcompris_template.ts gcompris_$locale.ts
./convertPo.py $poSource gcompris_$locale.ts $locale
rm $poSource
