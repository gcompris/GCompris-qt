#!/bin/bash

gcomprisGtkSourceDir=$1

if [ "$gcomprisGtkSourceDir" == "" ]
then
  echo "Usage: updateAll.sh gcomprisGtkSourceDir"
  exit 1
fi

# Get all the translation files
sources=$(ls ../../translations)

# Extract the locales
locales=''
for f in $sources
do
  locales+=$(echo $f | sed s/gcompris_// | sed s/\.ts//)" "
done

for locale in $locales
do
    echo "Processing $locale"
    # Remove some comment that breaks python polib
    poSource=$(mktemp posource_XXXXXXXXX)
    cat $gcomprisGtkSourceDir/$locale.po | grep -v "^#[\.\~]" > $poSource
    ./convertPo.py $poSource ../../translations/gcompris_$locale.ts $locale
    rm $poSource
    # Move the merged translation to the original directory
    mv gcompris_$locale.ts ../../translations/gcompris_$locale.ts
done