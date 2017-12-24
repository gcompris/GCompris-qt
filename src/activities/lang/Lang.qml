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
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation; either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
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

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/lang/resource/imageid-bg.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: Math.max(parent.width, parent.height)

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
            dialogActivityConfig.getInitialConfiguration()
            activity.audioVoices.error.connect(voiceError)
            activity.audioVoices.done.connect(voiceDone)
            Activity.start()
        }

        onStop: {
            dialogActivityConfig.saveDatainConfiguration()
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
            property BarEnumContent withConfig: BarEnumContent { value: help | home | config }
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
            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.setDefaultValues()
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
                parent: activity.main
                message: qsTr("We are sorry, we don't have yet a translation for your language.") + " " +
                         qsTr("GCompris is developed by the KDE community, you can translate GCompris by joining a translation team on <a href=\"%2\">%2</a>").arg("http://l10n.kde.org/") +
                         "<br /> <br />" +
                         qsTr("We switched to English for this activity but you can select another language in the configuration dialog.")
                onClose: background.englishFallback = false
            }
            anchors.fill: parent
            focus: true
            active: background.englishFallback
            onStatusChanged: if (status == Loader.Ready) item.start()
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias localeBox: localeBox
                    height: column.height

                    property alias availableLangs: langs.languages
                    LanguageList {
                        id: langs
                    }

                    Column {
                        id: column
                        spacing: 10
                        width: parent.width

                        Flow {
                            spacing: 5
                            width: dialogActivityConfig.width
                            GCComboBox {
                                id: localeBox
                                model: langs.languages
                                background: dialogActivityConfig
                                width: dialogActivityConfig.width
                                label: qsTr("Select your locale")
                            }
                        }
                    }
                }
            }

            onLoadData: {
                if(!dataToSave)
                    return

                if(dataToSave['locale']) {
                    items.locale = dataToSave["locale"];
                }
            }
            onSaveData: {
                // Save the lessons status on the current locale
                var oldLocale = items.locale
                dataToSave[ApplicationInfo.getVoicesLocale(items.locale)] =
                        Activity.lessonsToSavedProperties(dataToSave)

                if(!dialogActivityConfig.loader.item)
                    return

                var newLocale =
                        dialogActivityConfig.configItem.availableLangs[
                            dialogActivityConfig.loader.item.localeBox.currentIndex].locale;
                // Remove .UTF-8
                if(newLocale.indexOf('.') != -1) {
                    newLocale = newLocale.substring(0, newLocale.indexOf('.'))
                }
                dataToSave['locale'] = newLocale
                items.locale = newLocale;

                // Restart the activity with new information
                if(oldLocale !== newLocale) {
                    Activity.stop()
                    Activity.start();
                }
            }


            function setDefaultValues() {
                var localeUtf8 = items.locale;
                if(items.locale != "system") {
                    localeUtf8 += ".UTF-8";
                }

                for(var i = 0 ; i < dialogActivityConfig.configItem.availableLangs.length ; i ++) {
                    if(dialogActivityConfig.configItem.availableLangs[i].locale === localeUtf8) {
                        dialogActivityConfig.loader.item.localeBox.currentIndex = i;
                        break;
                    }
                }
            }
            onClose: home()
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
        "tool": qsTr("tool"), "food": qsTr("food")}

}
