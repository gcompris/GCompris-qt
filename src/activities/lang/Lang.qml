/* GCompris - lang.qml
*
* Copyright (C) Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*
* Authors:
*   Pascal Georges (pascal.georges1@free.fr) (GTK+ version)
*   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port of imageid)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Bruno Coudoin <bruno.coudoin@gcompris.net> (Integration Lang dataset)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0
import QtGraphicalEffects 1.0

import "../../core"
import "lang.js" as Activity
import "spell_it.js" as SpellActivity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    // When opening a dialog, it steals the focus and re set it to the activity.
    // We need to set it back to the active item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusEventInput();
        }
    }

    pageComponent: Rectangle {
        id: background
        color: "#85D8F6"
        anchors.fill: parent

        property bool englishFallback: false

        signal start
        signal stop
        signal voiceError
        signal voiceDone

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property GCAudio audioVoices: activity.audioVoices
            property alias background: background
            property alias bar: bar
            property alias imageReview: imageReview
            property alias parser: parser
            property alias menuModel: menuScreen.menuModel
            property var wordList
            property alias menuScreen: menuScreen
            property alias englishFallbackDialog: englishFallbackDialog
            property string locale: 'system'
            property alias dialogActivityConfig: dialogActivityConfig
            property var categoriesTranslations: activity.categoriesTranslations
        }

        onStart: {
            Activity.init(items)
            dialogActivityConfig.initialize()
            activity.audioVoices.error.connect(voiceError)
            activity.audioVoices.done.connect(voiceDone)
            Activity.start()
        }

        onStop: {
            dialogActivityConfig.saveData()
            Activity.stop()
        }

        JsonParser {
            id: parser
            onError: console.error("lang: Error parsing json: " + msg);
        }

        MenuScreen {
            id: menuScreen
        }

        ImageReview {
            id: imageReview
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            anchors.bottom: keyboardArea.top
            content: menuScreen.started ? withConfig : withoutConfig
            property BarEnumContent withConfig: BarEnumContent { value: help | home | activityConfig }
            property BarEnumContent withoutConfig: BarEnumContent { value: help | home }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onHomeClicked: {
                if(!items.menuScreen.started && !items.imageReview.started)
                    // We're in a mini game, start imageReview
                    items.imageReview.start()
                else if(items.imageReview.started)
                    // Leave imageReview
                    Activity.launchMenuScreen()
                else
                    home()
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        // This is a stop to hold the virtual keyboard from a mini game
        Row {
            id: keyboardArea
            anchors.bottom: parent.bottom
            width: parent.width
        }

        Loader {
            id: englishFallbackDialog
            sourceComponent: GCDialog {
                parent: activity
                isDestructible: false
                message: qsTr("We are sorry, we don't have yet a translation for your language.") + " " +
                         qsTr("GCompris is developed by the KDE community, you can translate GCompris by joining a translation team on <a href=\"%2\">%2</a>").arg("https://l10n.kde.org/") +
                         "<br /> <br />" +
                         qsTr("We switched to English for this activity but you can select another language in the configuration dialog.")
                onStart: {
                    menuScreen.stop();
                    forceActiveFocus();
                    parent.Keys.enabled = false;
                }
                onClose: {
                    background.englishFallback = false;
                    menuScreen.start();
                }
            }
            anchors.fill: parent
            focus: true
            active: background.englishFallback
            onStatusChanged: if (status == Loader.Ready) item.start()
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home();
            }
            onSaveData: {
                // Save progress for the locale
                activityData[ApplicationInfo.getVoicesLocale(items.locale)] =
                                    Activity.lessonsToSavedProperties()

                levelFolder = dialogActivityConfig.chosenLevels;
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels;
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels);
            }
            onLoadData: {
                if(activityData && activityData["locale"]) {
                    items.locale = Core.resolveLocale(activityData["locale"]);
                }
                else {
                    items.locale = Core.resolveLocale(items.locale);
                }
            }
            onStartActivity: {
                // Reload the locale information when restarting the activity
                loadData()
                background.start();
            }
        }
    }

    property var categoriesTranslations: {"otherChapter": qsTr("other"),
        "otherLesson": qsTr("other"),
        "action": qsTr("action"), "adjective": qsTr("adjective"),
        "color": qsTr("color"), "number": qsTr("number"),
        "people": qsTr("people"), "bodyparts": qsTr("bodyparts"),
        "clothes": qsTr("clothes"), "emotion": qsTr("emotion"),
        "job": qsTr("job"), "sport": qsTr("sport"),
        "nature": qsTr("nature"), "animal": qsTr("animal"),
        "fruit": qsTr("fruit"), "plant": qsTr("plant"),
        "vegetables": qsTr("vegetables"), "object": qsTr("object"),
        "construction": qsTr("construction"),
        "furniture": qsTr("furniture"), "houseware": qsTr("houseware"),
        "tool": qsTr("tool"), "food": qsTr("food"),
        "transport": qsTr("transport")}

}
