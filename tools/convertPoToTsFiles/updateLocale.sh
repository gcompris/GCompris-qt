#!/bin/bash

locale=$1
gcomprisGtkPoFile=$2

function usage { 
  echo "This tool is used to update a local .ts translation " \
       "from the string of the Gtk+ version"
  echo "Put the input file in this directory under the name gcompris_input_[locale].ts"
  echo "The resulting file is in gcompris_[locale].ts"
  echo "Usage: updateLocale.sh locale gcomprisGtkPoFile"
}

if [ "$locale" == "" -o "$gcomprisGtkPoFile" == "" ]
then
  usage
  exit 1
fi

if [ ! -f gcompris_input_$locale.ts ]
then
  echo "Put here the file gcompris_input_$locale.ts that you want to update"
  exit 1
fi


echo "Processing gcompris_input_$locale.ts"
# Remove some comment that breaks python polib
poSource=$(mktemp posource_XXXXXXXXX)
cat $gcomprisGtkPoFile | grep -v "^#[\.\~]" > $poSource
./convertPo.py $poSource gcompris_input_$locale.ts $locale
rm $poSource
echo "Updated file is in gcompris_$locale.ts"

