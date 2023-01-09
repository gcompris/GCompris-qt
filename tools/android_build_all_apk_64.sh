#!/bin/sh
# Automate the android builds
# This script creates the different apk for arm
#
# SPDX-FileCopyrightText: 2016 Bruno Coudoin <bruno.coudoin@gcompris.net>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

Qt5_BaseDIR=~/Qt/5.12.12
export ANDROID_NDK_ROOT=$ANDROID_NDK

if [ "$#" -eq 1 ]; then
    Qt5_BaseDIR=$1
    echo "Overriding Qt5_BaseDIR to ${Qt5_BaseDIR}"
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

    cmake -DCMAKE_TOOLCHAIN_FILE=/usr/share/ECM/toolchain/Android.cmake \
	  -DCMAKE_ANDROID_API=21 \
	  -DCMAKE_BUILD_TYPE=Release \
	  -DANDROID_ABI=$1 \
	  -DCMAKE_FIND_ROOT_PATH=${Qt5_BaseDIR}/${QtTarget}/lib/ \
	  -DQt5_DIR=${Qt5_BaseDIR}/${QtTarget}/lib/cmake/Qt5 \
	  -Wno-dev \
	  -DQML_BOX2D_MODULE=submodule \
	  -DWITH_DOWNLOAD=$2 \
	  -DWITH_KIOSK_MODE=$3 \
	  ${cmake_extra_args} \
	  ..

}

# ARM
QtTarget=android_arm64_v8a
builddir=${buildprefix}-${QtTarget}
mkdir -p ${builddir}
cd ${builddir}

# Retrieve the Qt version
if [[ $Qt5_BaseDIR =~ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
    version=${BASH_REMATCH[0]}
fi
n=${version//[!0-9]/ }
a=(${n//\./ })
major=${a[0]}
minor=${a[1]}
patch=${a[2]}

# If we use Qt > 5.14, we need to update some variables
if [[ $minor -ge 14 ]]; then
    echo "Using Qt5.14 or more";
    cmake_extra_args="-DANDROID_BUILD_ABI_arm64-v8a=ON"
    QtTarget=android
fi

f_cmake arm64-v8a ON OFF
make -j 4
make BuildTranslations
make apk_aligned_signed


# Remove extra apk
rm -f android-build/bin/*release-arm64*
rm -f android-build/bin/*release-signed-arm64*
