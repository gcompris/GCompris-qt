# Add more folders to ship with the application, here
folder_01.source = src
folder_01.target =
folder_02.source = menus
folder_02.target =
DEPLOYMENTFOLDERS = folder_01 folder_02

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

SOURCES += src/core/main.cpp \
	src/core/ActivityInfo.cpp \
	src/core/ActivityInfoTree.cpp

# Installation path
# target.path =

HEADERS += \
	src/core/ActivityInfo.h \
	src/core/ActivityInfoTree.h

RESOURCES += src/core/core.qrc \
	src/activities/leftright/resource.qrc

QT += core gui svg xml

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml

