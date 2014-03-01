cache()

TEMPLATE = app
QT += qml quick gui multimedia network xmlpatterns svg
//QT += core gui svg xml
TARGET = GCompris

include(src/core/core.pri)
include(src/activities/menu/menu.pri)

# Activity Includes
include(src/activities/memory/memory.pri)
include(src/activities/advanced_colors/advanced_colors.pri)
include(src/activities/instruments/instruments.pri)
#include(src/activities/ballcatch/ballcatch.pri)
#include(src/activities/clickgame/clickgame.pri)
include(src/activities/colors/colors.pri)
#include(src/activities/erase/erase.pri)
#include(src/activities/erase_clic/erase_clic.pri)
#include(src/activities/erase_2clic/erase_2clic.pri)
#include(src/activities/hexagon/hexagon.pri)
#include(src/activities/leftright/leftright.pri)

APP_FILES += \
	$$PWD/src/activities/activities.txt \

OTHER_FILES += $$APP_FILES

# Create the resource file
GENERATED_RESOURCE_FILE = $$OUT_PWD/gcompris.qrc

RESOURCE_CONTENT = \
	"<RCC>" \
	"<qresource>"

for(resourcefile, APP_FILES) {
	resourcefileabsolutepath = $$absolute_path($$resourcefile)
	relativepath_in = $$relative_path($$resourcefileabsolutepath, $$_PRO_FILE_PWD_)
	relativepath_out = $$relative_path($$resourcefileabsolutepath, $$OUT_PWD)
	RESOURCE_CONTENT += "<file alias=\"gcompris/$$relativepath_in\">$$relativepath_out</file>"
}

RESOURCE_CONTENT += \
	"</qresource>" \
	"</RCC>"

write_file($$GENERATED_RESOURCE_FILE, RESOURCE_CONTENT)|error("Aborting.")

RESOURCES += $$GENERATED_RESOURCE_FILE

android: ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
