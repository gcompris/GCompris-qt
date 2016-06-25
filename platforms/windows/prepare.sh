#!/bin/bash
#
# Before making a Windows build we must provide the converted mp3
# and the qm files because this is too annoying to create them on
# windows.

if [ ! -f CMakeLists.txt ]
then
   echo "ERROR: Run me from the top level project dir"
   exit 1
fi
mkdir -p build
cd build
cmake -D COMPRESSED_AUDIO=mp3 ..
make createMp3FromOgg
make BundleConvertedOggs
make getSvnTranslations
make BuildTranslations
make BundleTranslations
rsync -a ../converted_ogg_to_mp3-*.7z translations-*.7z gcompris.net:/var/www/download

#
# Then on Windows use the targets:
#
# DlAndInstallBundledTranslations
# DlAndInstallBundledConvertedOggs
#
