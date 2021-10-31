#!/bin/sh
# Automate the android builds
# This script creates the different apk for arm
#
# SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

# Uncomment if this is not already done
# make getSvnTranslations

Qt5_BaseDIR=~/Qt/5.12.5
export ANDROID_NDK_ROOT=$ANDROID_NDK

# The current version
version=$(sed -n -e 's/set(GCOMPRIS_MINOR_VERSION \([0-9]\+\)).*/\1/p' CMakeLists.txt)

# The prefix of the build dir, will be suffixed by the arch target
buildprefix=bb-$version

# Remove po files android do not support
rm -f po/*@*

#
if [ ! -f org.kde.gcompris.appdata.xml ]
then
    echo "ERROR: Run me from the top level GCompris source dir"
    exit 1
fi

# Param: ANDROID_ARCHITECTURE WITH_ACTIVATION_CODE DEMO_ONLY DOWNLOAD KIOSK_MODE
f_cmake()
{
    if [ $# != 5 ]
    then
	echo "f_cmake missing parameter"
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
	  ..

}

# ARM
QtTarget=android_armv7
builddir=${buildprefix}-${QtTarget}
mkdir -p ${builddir}
cd ${builddir}

f_cmake arm inapp OFF ON OFF
make -j 4
make BuildTranslations
make apk_release && make apk_signed && make apk_signed_aligned

f_cmake arm internal OFF ON OFF
make -j 4
make apk_release && make apk_signed && make apk_signed_aligned

f_cmake arm no OFF ON OFF
make -j 4
make apk_release && make apk_signed && make apk_signed_aligned

f_cmake arm no ON ON OFF
make clean
make -j 4
make BuildTranslations
make apk_release && make apk_signed && make apk_signed_aligned

# Remove extra apk
rm -f android/bin/*release-armeabi*
rm -f android/bin/*release-signed-armeabi*
