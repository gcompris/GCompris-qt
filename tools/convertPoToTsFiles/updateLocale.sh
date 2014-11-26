#!/bin/bash

locale=$1
gcomprisGtkSourceDir=$2

function usage {
  echo "Usage: updateLocale.sh locale gcomprisGtkSourceDir"
}

if [ "$locale" == "" -o "$gcomprisGtkSourceDir" == "" ]
then
  usage
  exit 1
fi

if [ ! -f ../../src/gcompris_$locale.ts ]
then
    echo "Create first the gcompris_$locale.ts file with:"
    cd ../../src
    mkdir -p translations
    lupdate `find . -name \*.cpp -o -name \*.h -o -name \*.qml` -ts translations/gcompris_kn.ts
    if [ $? -ne 0 ]
    then
	echo "Failed to run lupdate"
	cd -
	exit 1
    fi
    cd -
fi

echo "Processing $locale"
# Remove some comment that breaks python polib
poSource=$(mktemp posource_XXXXXXXXX)
cat $gcomprisGtkSourceDir/$locale.po | grep -v "^#[\.\~]" > $poSource
./convertPo.py $poSource ../../src/translations/gcompris_$locale.ts $locale
rm $poSource
# Move the merged translation to the original directory
mv gcompris_$locale.ts ../../src/translations/gcompris_$locale.ts
# Convert it to have the qm file ready
lconvert ../../src/translations/gcompris_$locale.ts -o ../../src/translations/gcompris_$locale.qm
echo "You must manually copy the file ../../src/translations/gcompris_$locale.qm in your build dir under bin/translations"
