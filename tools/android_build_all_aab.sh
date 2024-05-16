#!/bin/sh
# Automate the android builds
# This script creates the aab for Android
#
# SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

Qt6_BaseDIR=~/Qt6/6.6.3
export ANDROID_NDK_ROOT=$ANDROID_NDK

if [ "$#" -eq 1 ]; then
    Qt6_BaseDIR=$1
    echo "Overriding Qt6_BaseDIR to ${Qt6_BaseDIR}"
fi

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

# Param: ANDROID_ABI DOWNLOAD KIOSK_MODE
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

    ${Qt6_BaseDIR}/android_x86_64/bin/qt-cmake \
          -DCMAKE_ANDROID_API=26 \
          -DANDROID_PLATFORM=26 \
	  -DCMAKE_BUILD_TYPE=Release \
	  -Wno-dev \
	  -DQML_BOX2D_MODULE=submodule \
	  -DWITH_DOWNLOAD=$2 \
	  -DWITH_KIOSK_MODE=$3 \
	  ${cmake_extra_args} \
	  ..

}

# ARM
QtTarget=android
builddir=${buildprefix}-${QtTarget}
mkdir -p ${builddir}
cd ${builddir}

cmake_extra_args="-DQT_ANDROID_BUILD_ALL_ABIS=true"
QtTarget=android

f_cmake android ON OFF
make -j 4
make aab_release
