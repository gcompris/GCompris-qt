#!/bin/sh
# Automate the android builds
# This script creates the different apk for arm
#
# SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
	rm -f CMakeCache.txt
	rm -f cmake_install.cmake
        rm -f Makefile
        rm -rf CMakeFiles
    fi

    cmake -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
          -DCMAKE_ANDROID_API=26 \
          -DANDROID_PLATFORM=26 \
	  -DCMAKE_BUILD_TYPE=Release \
	  -DANDROID_ABI=$1 \
	  -DCMAKE_FIND_ROOT_PATH=${Qt6_BaseDIR}/${QtTarget}/lib/ \
	  -DQt6_DIR=${Qt6_BaseDIR}/${QtTarget}/lib/cmake/Qt6 \
	  -Wno-dev \
	  -DQML_BOX2D_MODULE=submodule \
	  -DWITH_DOWNLOAD=$2 \
	  -DWITH_KIOSK_MODE=$3 \
	  ${cmake_extra_args} \
	  ..

}

# ARM
QtTarget=android_armv7
builddir=${buildprefix}-${QtTarget}
mkdir -p ${builddir}
cd ${builddir}

# Retrieve the Qt version
if [[ $Qt6_BaseDIR =~ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
    version=${BASH_REMATCH[0]}
fi
n=${version//[!0-9]/ }
a=(${n//\./ })
major=${a[0]}
minor=${a[1]}
patch=${a[2]}

f_cmake armeabi-v7a ON OFF
make -j 4
make apk_aligned_signed

# Remove extra apk
rm -f android-build/bin/*release-armeabi*
rm -f android-build/bin/*release-signed-armeabi*
