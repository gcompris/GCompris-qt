#!/bin/sh
# Automate the android builds
# This script creates the different apk for arm
#
# SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

# Uncomment if this is not already done
# make getSvnTranslations

Qt5_BaseDIR=~/Qt/5.12.6
export ANDROID_NDK_ROOT=$ANDROID_NDK
export ANDROID_ARCH=arm64
export ANDROID_ARCH_ABI=arm64-v8a
export Qt5_android=${Qt5_BaseDIR}/${QtTarget}/

# The current version
version=$(sed -n -e 's/set(GCOMPRIS_MINOR_VERSION \([0-9]\+\)).*/\1/p' CMakeLists.txt)

# The prefix of the build dir, will be suffixed by the arch target
buildprefix=bb-$version

#
if [ ! -f org.kde.gcompris.appdata.xml ]
then
    echo "ERROR: Run me from the top level GCompris source dir"
    exit 1
fi

# Param: ANDROID_ARCHITECTURE DOWNLOAD KIOSK_MODE
f_cmake()
{
    if [ $# != 3 ]
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
	  -DCMAKE_ANDROID_API=22 \
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
	  -DWITH_DOWNLOAD=$2 \
	  -DWITH_KIOSK_MODE=$3 \
	  ..

}

# ARM
QtTarget=android_arm64_v8a
builddir=${buildprefix}-${QtTarget}
mkdir -p ${builddir}
cd ${builddir}

f_cmake arm64 ON OFF
make -j 4
make BuildTranslations
make apk_release && make apk_aligned && make apk_aligned_signed


# Remove extra apk
rm -f android/bin/*release-arm64*
rm -f android/bin/*release-signed-arm64*
