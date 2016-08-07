#!/bin/sh
# Automate the build of the source dist
# This script creates a branch, integrate the po and
# create the tarball
#

if [ ! -f gcompris.appdata.xml ]
then
    echo "ERROR: Run me from the top level GCompris source dir"
    exit 1
fi

# The current version
version=$(sed -n -e 's/set(GCOMPRIS_MINOR_VERSION \([0-9]\+\)).*/\1/p' CMakeLists.txt)

# Uncomment if this is not already done
git checkout -b 0.${version}-po
mkdir -p build
cd build
cmake ..
make getSvnTranslations
git add -f ../po
git commit -a -m "PO INTEGRATED / DO NOT PUSH ME"
make dist
git checkout 0.${version}
git branch -D 0.${version}-po
