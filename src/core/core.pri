SOURCES += \
	$$PWD/ActivityInfo.cpp \
	$$PWD/ActivityInfoTree.cpp \
	$$PWD/main.cpp

HEADERS += \
	$$PWD/ActivityInfo.h \
	$$PWD/ActivityInfoTree.h

APP_FILES = \
	$$PWD/ActivityBase.qml \
	$$PWD/BarButton.qml \
	$$PWD/BarEnumContent.qml \
	$$PWD/Bar.qml \
	$$PWD/DialogAbout.qml \
	$$PWD/DialogBackground.qml \
	$$PWD/DialogHelp.qml \
	$$PWD/GCButtonStyle.qml \
	$$PWD/main.qml

include(resource/resource.pri)

OTHER_FILES += \
    src/core/ActivityBase.qml
