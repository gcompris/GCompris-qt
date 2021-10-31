# Minimal .pro file to create an initial xcode project

TEMPLATE = app
TARGET = gcompris
INCLUDEPATH += .
QT += qml quick gui multimedia network svg core
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

ios {
    QMAKE_INFO_PLIST = platforms/ios/Info.plist
}

ios {
    rccFiles.files = rcc
    rccFiles.path = .
    translationFiles.files = translations
    translationFiles.path = .
    QMAKE_BUNDLE_DATA += rccFiles translationFiles
}

ios {
    assets_catalogs.files = $$files($$PWD/platforms/ios/*.xcassets)
    QMAKE_BUNDLE_DATA += assets_catalogs
}



#target.path = $$[QT_INSTALL_EXAMPLES]/quick/animation
#INSTALLS += target
