#!/bin/bash
# Automate the gcompris package
#
# SPDX-FileCopyrightText: 2025 Johnny Jazeix <jazeix@gmail.com>
#
#   SPDX-License-Identifier: GPL-3.0-or-later

# ================================================================
# This script builds both GCompris and GCompris-teachers packages.
# ================================================================

Qt6_BaseDIR=~/Qt6/6.6.3
QtTarget=gcc_64

if [ "$#" -eq 1 ]; then
    Qt6_BaseDIR=$1
    echo "Overriding Qt6_BaseDIR to ${Qt6_BaseDIR}"
fi

# The current version
version=$(sed -n -e 's/set(GCOMPRIS_MINOR_VERSION \([0-9]\+\)).*/\1/p' CMakeLists.txt)

#
if [ ! -f org.kde.gcompris.appdata.xml ]
then
    echo "ERROR: Run me from the top level GCompris source dir"
    exit 1
fi

f_cmake()
{
    if [ -f CMakeCache.txt ]
    then
	make clean
	rm -f CMakeCache.txt
	rm -f cmake_install.cmake
        rm -f Makefile
        rm -rf CMakeFiles
    fi

    cmake -DCMAKE_BUILD_TYPE=Release \
	  -DQt6_DIR=${Qt6_BaseDIR}/${QtTarget}/lib/cmake/Qt6 \
	  -Wno-dev \
	  -DQML_BOX2D_MODULE=submodule \
	  -DBUILD_STANDALONE=ON \
	  -DPACKAGE_GCOMPRIS=$1 \
	  -DPACKAGE_SERVER=$2 \
	  ..

}

# Retrieve the Qt version
if [[ $Qt6_BaseDIR =~ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
    version=${BASH_REMATCH[0]}
fi
n=${version//[!0-9]/ }
a=(${n//\./ })
major=${a[0]}
minor=${a[1]}
patch=${a[2]}

# The prefix of the build dir
buildprefix=gcompris-qt-$version
builddir=${buildprefix}-${QtTarget}
mkdir -p ${builddir}
cd ${builddir}

f_cmake ON OFF
make -j 4 package
cd ..

# Package server
buildprefix=gcompris-teachers-$version
builddir=${buildprefix}-${QtTarget}
mkdir -p ${builddir}
cd ${builddir}
f_cmake OFF ON
make -j 4 package
cd ..
