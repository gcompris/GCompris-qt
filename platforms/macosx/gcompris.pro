# Minimal .pro file to create an initial xcode project

TEMPLATE = app
TARGET = gcompris
CONFIG += c++11
INCLUDEPATH += .
QT += qml quick gui multimedia network xmlpatterns svg xml core
APPCERT = "3rd Party Mac Developer Application: Bruno Coudoin"
INSTALLERCERT = "3rd Party Mac Developer Installer: Bruno Coudoin"
BUNDLEID = net.gcompris
ENTITLEMENTS = platform/macosx/gcompris.entitlements

QMAKE_CFLAGS_RELEASE = $$QMAKE_CFLAGS_RELEASE_WITH_DEBUGINFO
QMAKE_CXXFLAGS_RELEASE = $$QMAKE_CXXFLAGS_RELEASE_WITH_DEBUGINFO
QMAKE_OBJECTIVE_CFLAGS_RELEASE =  $$QMAKE_OBJECTIVE_CFLAGS_RELEASE_WITH_DEBUGINFO
QMAKE_LFLAGS_RELEASE = $$QMAKE_LFLAGS_RELEASE_WITH_DEBUGINFO

# Input
HEADERS += src/core/ActivityInfo.h \
           src/core/ActivityInfoTree.h \
           src/core/ApplicationInfo.h \
           src/core/ApplicationSettings.h \
           src/core/DownloadManager.h \
           src/core/File.h
SOURCES += src/core/ActivityInfo.cpp \
           src/core/ApplicationInfoDefault.cpp \
           src/core/ActivityInfoTree.cpp \
           src/core/ApplicationInfo.cpp \
           src/core/ApplicationSettings.cpp \
           src/core/ApplicationSettingsDefault.cpp \
           src/core/DownloadManager.cpp \
           src/core/File.cpp \
           src/core/main.cpp

ICON = gcompris.icns

QMAKE_INFO_PLIST = platforms/macosx/Info.plist
OTHER_FILES += platforms/macosx/Info.plist
               $${ENTITLEMENTS}

codesign.depends  += all
codesign.commands += macdeployqt $${TARGET}.app;

rccFiles.files = rcc
rccFiles.path = Contents/Resources
translationFiles.files = translations
translationFiles.path = Contents/Resources/
QMAKE_BUNDLE_DATA += rccFiles translationFiles

QMAKE_CFLAGS += -gdwarf-2
QMAKE_CXXFLAGS += -gdwarf-2

codesign.depends  += all
codesign.commands += macdeployqt $${TARGET}.app;

# Sign frameworks and plug-ins (uncomment and change to suit your application)
#codesign -s "$APPCERT" -i $BUNDLEID $${TARGET}.app/Contents/Frameworks/QtCore.framework/Versions/4/QtCore
#codesign -s "$APPCERT" -i $BUNDLEID $${TARGET}.app/Contents/PlugIns/imageformats/libqjpeg.dylib
    
# Sign the application bundle, using the provided entitlements
codesign.commands += codesign -f -s \"$${APPCERT}\" -v –entitlements $${ENTITLEMENTS} $${TARGET}.app;

product.depends += all
    
# Build the product package
product.commands += productbuild --component $${TARGET}.app /Applications --sign \"$${INSTALLERCERT}\" $${TARGET}.pkg;

QMAKE_EXTRA_TARGETS += codesign product copyfiles

