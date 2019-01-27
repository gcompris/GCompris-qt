/* GCompris - ClickOnLetter.qml
 *
 * Copyright (C) 2014 Holger Kaelberer  <holger.k@elberer.de>
 *
 * Authors:
 *   Pascal Georges <pascal.georges1@free.fr> (GTK+ version)
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ Mostly full rewrite)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
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
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import QtGraphicalEffects 1.0
import GCompris 1.0
import "../../core"
import "click_on_letter.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity
    focus: true

    /* mode of the activity, either "lowercase" (click_on_letter)
     * or "uppercase" (click_on_letter_up): */
    property string mode: "lowercase"

    onStart: focus = true

    pageComponent: Image {
        id: background
        source: Activity.url + "background.svg"
        sourceSize.width: Math.max(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop
        focus: true

        // system locale by default
        property string locale: "system"

        signal start
        signal stop
        signal voiceError

        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property alias bar: bar
            property alias trainModel: trainModel
            property GCAudio audioVoices: activity.audioVoices
            property alias parser: parser
            property alias questionItem: questionItem
            property alias repeatItem: repeatItem
            property alias score: score
            property alias bonus: bonus
            property alias locale: background.locale
        }

        onVoiceError: {
            questionItem.visible = true
            repeatItem.visible = false
        }

        onStart: {
            activity.audioVoices.error.connect(voiceError)
            Activity.start(items, mode);
        }

        onStop: Activity.stop()

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
                                label: qsTr("Select your locale")
                            }
                        }
                    }
                }
            }

            onClose: home()
            onLoadData: {
                if(dataToSave && dataToSave["locale"]) {
                    background.locale = dataToSave["locale"];
                }
            }
            onSaveData: {
                var oldLocale = background.locale;
                var newLocale =
                dialogActivityConfig.configItem.availableLangs[dialogActivityConfig.loader.item.localeBox.currentIndex].locale;
                // Remove .UTF-8
                if(newLocale.indexOf('.') != -1) {
                    newLocale = newLocale.substring(0, newLocale.indexOf('.'))
                }
                dataToSave = {"locale": newLocale }

                background.locale = newLocale;

                // Restart the activity with new information
                if(oldLocale !== newLocale) {
                    background.stop();
                    background.start();
                }
            }

            function setDefaultValues() {
                var localeUtf8 = background.locale;
                if(background.locale != "system") {
                    localeUtf8 += ".UTF-8";
                }

                for(var i = 0 ; i < dialogActivityConfig.configItem.availableLangs.length ; i ++) {
                    if(dialogActivityConfig.configItem.availableLangs[i].locale === localeUtf8) {
                        dialogActivityConfig.loader.item.localeBox.currentIndex = i;
                        break;
                    }
                }
            }
        }

        DialogHelp {
            id: dialogHelpLeftRight
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | config }
            onHelpClicked: {
                displayDialog(dialogHelpLeftRight)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: home()
            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.setDefaultValues()
                displayDialog(dialogActivityConfig)
            }
        }

        Score {
            id: score
            anchors.top: parent.top
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.left: parent.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: undefined
            anchors.right: undefined
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg";
            sourceSize.width: 80 * ApplicationInfo.ratio
            anchors {
                top: parent.top
                right: parent.right
                margins: 10
            }
            onClicked: Activity.playLetter(Activity.currentLetter);
        }

        Image {
            id: railway
            source: Activity.url + "railway.svg"
            fillMode: Image.PreserveAspectCrop
            anchors.bottom: bar.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 15 * ApplicationInfo.ratio
            sourceSize.width: Math.max(parent.width, parent.height)
            anchors.bottomMargin: 13 * ApplicationInfo.ratio
        }

        Item {
            id: questionItem
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.topMargin: parent.height * 0.25
            z: 10
            width: questionText.width * 2
            height: questionText.height * 1.3
            visible: false

            property alias text: questionText.text

            Rectangle {
                id: questionRect
                anchors.fill: parent
                border.color: "#FFFFFFFF"
                border.width: 2
                color: "#000065"
                opacity: 0.31
                radius: 10
            }

            GCText {
                id: questionText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                opacity: 1.0
                z:11
                text: ""
                fontSize: 44
                font.bold: true
                style: Text.Outline
                styleColor: "#2a2a2a"
                color: "white"
            }

            DropShadow {
                anchors.fill: questionText
                cached: false
                horizontalOffset: 1
                verticalOffset: 1
                radius: 3
                samples: 16
                color: "#422a2a2a"
                source: questionText
            }
        }

        ListModel {
            id: trainModel
        }

        property int itemWidth: Math.min(parent.width / 7.5, parent.height / 5)
        property int itemHeight: itemWidth * 1.11

        Image {
            id: engine
            source: Activity.url + "engine.svg"
            anchors.bottom: railway.bottom
            anchors.left: railway.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottomMargin: 5 * ApplicationInfo.ratio
            sourceSize.width: itemWidth
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: smoke
            source: Activity.url + "smoke.svg"
            anchors.bottom: engine.top
            anchors.left: railway.left
            anchors.leftMargin: 10 * ApplicationInfo.ratio
            anchors.bottomMargin: 5 * ApplicationInfo.ratio
            sourceSize.width: itemWidth
            fillMode: Image.PreserveAspectFit
        }

        GridView {
            id: train
            anchors.bottom: railway.bottom
            anchors.left: engine.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottomMargin: 5 * ApplicationInfo.ratio
            cellWidth: itemWidth
            cellHeight: itemHeight
            clip: false
            interactive: false
            verticalLayoutDirection: GridView.BottomToTop
            layoutDirection: Qt.LeftToRight

            model: trainModel
            delegate: Carriage {
                width: background.itemWidth
                nbCarriage: (parent.width - engine.width) / background.itemWidth
            }
        }

        JsonParser {
            id: parser
            onError: console.error("Click_on_letter: Error parsing JSON: " + msg);
        }

    }
}
