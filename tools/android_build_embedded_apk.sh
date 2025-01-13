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

Qt6_BaseDIR=~/Qt6/6.6.3
export ANDROID_NDK_ROOT=$ANDROID_NDK

if [ "$#" -eq 1 ]; then
    Qt6_BaseDIR=$1
    echo "Overriding Qt6_BaseDIR to ${Qt6_BaseDIR}"
fi

# The current version
version=$(sed -n -e 's/set(GCOMPRIS_MINOR_VERSION \([0-9]\+\)).*/\1/p' CMakeLists.txt)

# The prefix of the build dir, will be suffixed by the arch target
buildprefix=emb-$version

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

# Param: ANDROID_ABI DOWNLOAD KIOSK_MODE DOWNLOAD_ASSETS
# DOWNLOAD_ASSETS: list of assets to bundle in the apk
#  e.g: words,en,fr,music # This packages the large words rcc, the french and english voices, and the music
f_cmake()
{
    if [ $# != 4 ]
    then
	echo "f_cmake parameter number mismatch"
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
	  -DCMAKE_PREFIX_PATH=${Qt6_BaseDIR}/${QtTarget}/lib/cmake/Qt6 \
	  -Wno-dev \
	  -DQML_BOX2D_MODULE=submodule \
	  -DWITH_DOWNLOAD=$2 \
	  -DWITH_KIOSK_MODE=$3 \
	  -DDOWNLOAD_ASSETS=$4 \
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

f_cmake armeabi-v7a OFF OFF $download_assets
make -j 16
make getAssets
make apk_aligned_signed

# Remove extra apk
rm -f android-build/*release-armeabi*
rm -f android-build/*release-signed-armeabi*
