#!/bin/bash
# Automate the android builds
# This script creates the different apk for arm and x86
#
# Copyright (C) 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, see <https://www.gnu.org/licenses/>.

# =======================================================================
# This script builds an 'embedded' apk that includes a list of resources.
# =======================================================================

#
# Uncomment if this is not already done
# make getSvnTranslations

Qt5_BaseDIR=~/Qt5.4.2/5.4
export ANDROID_NDK_ROOT=$ANDROID_NDK

# The current version
version=$(sed -n -e 's/set(GCOMPRIS_MINOR_VERSION \([0-9]\+\)).*/\1/p' CMakeLists.txt)

# The prefix of the build dir, will be suffixed by the arch target
buildprefix=emb-$version

# Remove po files android do not support
rm -f po/*@*

#
if [ ! -f gcompris.appdata.xml ]
then
    echo "ERROR: Run me from the top level GCompris source dir"
    exit 1
fi

if [ "$#" == "0" ]
then
    echo "ERROR: Missing download asset parameter (e.g: words,en,fr)"
    exit 1
fi
download_assets=$1

# Param: ANDROID_ARCHITECTURE WITH_ACTIVATION_CODE DEMO_ONLY DOWNLOAD KIOSK_MODE DOWNLOAD_ASSETS
# DOWNLOAD_ASSETS: list of assets to bundle in the apk
#  e.g: words,en,fr # This packages the large words rcc, the french and english voices
f_cmake()
{
    if [ $# != 6 ]
    then
	echo "f_cmake parameter number mismatch"
	return
    fi

    if [ -f CMakeCache.txt ]
    then
	make clean
	rm CMakeCache.txt
	rm cmake_install.cmake
        rm Makefile
        rm -rf CMakeFiles
    fi

    cmake -DCMAKE_TOOLCHAIN_FILE=/usr/share/ECM/toolchain/Android.cmake \
	  -DCMAKE_BUILD_TYPE=release \
	  -DANDROID_ARCHITECTURE=$1 \
	  -DQt5_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5 \
	  -Wno-dev \
	  -DQML_BOX2D_MODULE=submodule \
	  -DACTIVATION_MODE=$2 \
	  -DWITH_DEMO_ONLY=$3 \
	  -DWITH_DOWNLOAD=$4 \
	  -DWITH_KIOSK_MODE=$5 \
          -DDOWNLOAD_ASSETS=$6 \
	  ..

}

# ARM
QtTarget=android_armv7
builddir=${buildprefix}-${QtTarget}
mkdir -p ${builddir}
cd ${builddir}


f_cmake arm no OFF OFF OFF $download_assets
make
make BuildTranslations
make getAssets
make apk_release && make apk_signed && make apk_signed_aligned

# Remove extra apk
rm -f android/bin/*release-arm*
rm -f android/bin/*release-signed-arm*
