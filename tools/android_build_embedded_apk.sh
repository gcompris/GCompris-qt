#!/bin/bash
# Automate the android builds
# This script creates the different apk for arm and x86
#
# SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

# =======================================================================
# This script builds an 'embedded' apk that includes a list of resources.
# =======================================================================

#
# Uncomment if this is not already done
# make getSvnTranslations

Qt5_BaseDIR=~/Qt/5.12.6
export ANDROID_NDK_ROOT=$ANDROID_NDK

# The current version
version=$(sed -n -e 's/set(GCOMPRIS_MINOR_VERSION \([0-9]\+\)).*/\1/p' CMakeLists.txt)

# The prefix of the build dir, will be suffixed by the arch target
buildprefix=emb-$version

# Remove po files android do not support
rm -f po/*@*

#
if [ ! -f org.kde.gcompris.appdata.xml ]
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
#  e.g: words,en,fr,music # This packages the large words rcc, the french and english voices, and the music
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

    cmake -DCMAKE_TOOLCHAIN_FILE=~/ecm/share/ECM/toolchain/Android.cmake \
	  -DCMAKE_BUILD_TYPE=release \
	  -DANDROID_ARCHITECTURE=$1 \
	  -DQt5_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5 \
	  -DQt5Qml_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5Qml \
	  -DQt5Network_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5Network \
	  -DQt5Core_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5Core \
	  -DQt5Quick_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5Quick \
	  -DQt5Gui_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5Gui \
	  -DQt5Multimedia_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5Multimedia \
	  -DQt5Svg_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5Svg \
	  -DQt5Widgets_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5Widgets \
	  -DQt5LinguistTools_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5LinguistTools \
	  -DQt5Sensors_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5Sensors \
	  -DQt5AndroidExtras_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5AndroidExtras \
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
rm -f android/*release-arm*
rm -f android/*release-signed-arm*
