# Add more folders to ship with the application, here
folder_01.source = qml
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

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    ActivityInfo.cpp \
    ActivityInfoTree.cpp

# Installation path
# target.path =

HEADERS += \
    ActivityInfo.h \
    ActivityInfoTree.h

RESOURCES += qml/core/core.qrc \
	qml/leftright-activity/resource.qrc

QT += core gui svg xml

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

