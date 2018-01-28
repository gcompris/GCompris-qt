#!/bin/sh
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
#   along with this program; if not, see <http://www.gnu.org/licenses/>.

# Uncomment if this is not already done
# make getSvnTranslations

Qt5_BaseDIR=~/Qt5.9.3/5.9.3
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
	  -DQt5Qml_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Qml \
	  -DQt5Network_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Network \
	  -DQt5Core_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Core \
	  -DQt5Quick_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Quick \
	  -DQt5Gui_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Gui \
	  -DQt5Multimedia_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Multimedia \
	  -DQt5Svg_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Svg \
	  -DQt5Widgets_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Widgets \
	  -DQt5Xml_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Xml \
	  -DQt5XmlPatterns_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5XmlPatterns \
	  -DQt5LinguistTools_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5LinguistTools \
	  -DQt5Sensors_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5Sensors \
	  -DQt5AndroidExtras_DIR=~/Qt5.9.3/5.9.3/android_armv7/lib/cmake/Qt5AndroidExtras \
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

f_cmake armeabi inapp OFF ON OFF
make
make BuildTranslations
make apk_release && make apk_signed && make apk_signed_aligned

f_cmake armeabi internal OFF ON OFF
make
make apk_release && make apk_signed && make apk_signed_aligned

f_cmake armeabi no OFF ON OFF
make
make apk_release && make apk_signed && make apk_signed_aligned

f_cmake armeabi no ON ON OFF
make clean
make
make BuildTranslations
make apk_release && make apk_signed && make apk_signed_aligned

# Remove extra apk
rm -f android/bin/*release-armeabi*
rm -f android/bin/*release-signed-armeabi*

# X86
cd ..
QtTarget=android_x86
builddir=${buildprefix}-${QtTarget}
mkdir -p ${builddir}
cd ${builddir}

f_cmake x86 inapp OFF ON OFF
make
make BuildTranslations
make apk_release && make apk_signed && make apk_signed_aligned

f_cmake x86 internal OFF ON OFF
make
make apk_release && make apk_signed && make apk_signed_aligned

f_cmake x86 no OFF ON OFF
make
make apk_release && make apk_signed && make apk_signed_aligned

f_cmake x86 no ON ON OFF
make
make apk_release && make apk_signed && make apk_signed_aligned

# Remove extra apk
rm -f android/bin/*release-x86*
rm -f android/bin/*release-signed-x86*
