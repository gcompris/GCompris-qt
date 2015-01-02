#!/bin/bash

locale=$1
gcomprisGtkPoFile=$2

function usage { 
  echo "This tool is used to update a local .ts translation " \
       "from the string of the Gtk+ version"
  echo "Put the input file in this directory under the name gcompris_input_[locale].ts"
  echo "The resulting file is in gcompris_[locale].ts"
  echo ""
  echo "Assuming:"
  echo "  The current KDE po file is ~/kde/gcompris_fr.po"
  echo "  The Gtk+ po file is ~/gcompris-gtk/po/fr.po"
  echo "  lupdate and lconvert are the Qt5 ones"
  echo ""
  echo "Example for the fr locale:"
  echo "  git clone git://anongit.kde.org/gcompris.git"
  echo "  cd gcompris/tools/convertPoToTsFiles"
  echo "  cp ~/kde/gcompris_fr.po gcompris_input_fr.po"
  echo "  lupdate gcompris_fr_input.po -ts gcompris_fr_input.ts"
  echo "  ./updateLocale.sh fr ~/gcompris-gtk/po/fr.po"
  echo "  lconvert -i gcompris_fr.ts -o gcompris_fr.po"
  echo ""
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

