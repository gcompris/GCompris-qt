#!/bin/sh
# Automate the build of the source dist
# This script creates a branch, integrate the po and
# create the tarball
#

# The current version
version=$(sed -n -e 's/set(GCOMPRIS_MINOR_VERSION \([0-9]\+\)).*/\1/p' CMakeLists.txt)

# Uncomment if this is not already done
git co -b 0.${version}-po
mkdir -p build
cd build
make getSvnTranslations
git add -f ../po
git ci -a -m "PO INTEGRATED / DO NOT PUSH ME"
make dist
