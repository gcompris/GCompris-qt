#!/bin/sh
# Automate the build of the source dist
# This script creates a branch, integrate the po and
# create the tarball
#
# SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

if [ ! -f org.kde.gcompris.appdata.xml ]
then
    echo "ERROR: Run me from the top level GCompris source dir"
    exit 1
fi

# The current version
version=$(sed -n -e 's/set(GCOMPRIS_MINOR_VERSION \([0-9]\+\)).*/\1/p' CMakeLists.txt)
curbranch=$(git rev-parse --abbrev-ref HEAD)

# Uncomment if this is not already done
git checkout -b 0.${version}-po
mkdir -p build
cd build
cmake ..

# remove all translation files that should not be shipped
# get all the locales to keep from LanguageList.qml
languageListToKeep=`grep UTF-8\" ../src/core/LanguageList.qml | grep -v "//" | grep -o '[a-zA-Z_@]*.UTF-8' | cut -d'.' -f1`
fullLanguageList=`echo $languageListToKeep | xargs`
for f in $languageListToKeep; do
    # append short locales to the list
    fullLanguageList="$fullLanguageList `echo $f | cut -d'_' -f1`"
done
# remove each po file that is not within the previous list
for f in ../poqm/*/gcompris_qt.po; do
    # get the locale from the filename
    locale=`echo $f | cut -d'/' -f3- | cut -d'/' -f1`
    echo $fullLanguageList | grep -q -w $locale
    if [[ $? -ne 0 ]]; then
        echo "Removing $locale as it is not shipped within gcompris"
        rm -f $f
    fi
done

git add -f ../poqm
# Remove the po from po/ folder, they are unused
git rm -rf ../po
git commit -a -m "PO INTEGRATED / DO NOT PUSH ME"
make dist
git checkout ${curbranch}
git branch -D 0.${version}-po
