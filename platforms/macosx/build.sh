#!/bin/sh

mkdir -p translations
# Put the qm file manually here

mkdir -p rcc
mkdir build
cd build
cmake ..
make createAacFromOgg
make
cp bin/gcompris-qt.app/Contents/Resources/rcc/*.rcc ../rcc/
cd ..

cp platforms/macosx/config.h .
cp platforms/macosx/gcompris.pro .
cp platforms/macosx/gcompris.icns .


mkdir -p build-macosx
cd build-macosx
~/Qt/5.5/clang_64/bin/qmake -config release ../gcompris.pro
make
codesign --deep -s "3rd Party Mac Developer Application: Bruno Coudoin" --entitlements ../platforms/macosx/gcompris.entitlements gcompris.app
/Users/bdoin/Qt/5.5/clang_64//bin/macdeployqt gcompris.app  -executable=/Users/bdoin/Projets/gcompris/build-macosx/gcompris.app/Contents/MacOS/gcompris  -always-overwrite -qmldir=/Users/bdoin/Projets/gcompris/src  -codesign="3rd Party Mac Developer Application: Bruno Coudoin" -verbose=2
codesign --deep -s "3rd Party Mac Developer Application: Bruno Coudoin" gcompris.app/Contents/Resources/translations/*
codesign --deep -s "3rd Party Mac Developer Application: Bruno Coudoin" gcompris.app/Contents/Resources/rcc/*
make product

echo 'To test it:'
echo 'sudo installer -store -pkg gcompris.pkg -target /'

