/* GCompris - LetterInWord.qml
 *
 * Copyright (C) 2014 Holger Kaelberer  <holger.k@elberer.de>
 *               2016 Akshat Tandon     <akshat.tandon@research.iiit.ac.in>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de> (Click on Letter - Qt Quick port)
 *   Akshat Tandon    <akshat.tandon@research.iiit.ac.in> (Modifications to Click on Letter code
 *                                                           to make Letter in which word activity)
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
import QtQuick.Controls 1.5
import GCompris 1.0
import "../../core"
import "letter-in-word.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity
    focus: true

    onStart: focus = true

    pageComponent: Image {
        id: background
        source: Activity.resUrl + "hillside.svg"
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectCrop
        focus: true

        // system locale by default
        property string locale: "system"

        property bool englishFallback: false

        property bool keyboardMode: false

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
            property alias background: background
            property alias wordsModel: wordsModel
            property int currentLetterCase: ApplicationSettings.fontCapitalization
            property int currentMode: normalModeWordCount
            readonly property int easyModeWordCount: 5
            readonly property int normalModeWordCount: 11
            property GCAudio audioVoices: activity.audioVoices
            property alias parser: parser
            property alias animateX: animateX
            property alias repeatItem: repeatItem
            property alias score: score
            property alias bonus: bonus
            property alias locale: background.locale
            property alias questionItem: questionItem
            property alias englishFallbackDialog: englishFallbackDialog
            property string question
        }

        onStart: {
            activity.audioVoices.error.connect(voiceError)
            Activity.start(items);
        }

        onStop: Activity.stop()

        onWidthChanged: {
                animateX.restart();
        }

        onHeightChanged: {
                animateX.restart();
        }

        ExclusiveGroup {
            id: configOptions
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    property alias localeBox: localeBox
                    property alias easyModeConfig: easyModeConfig
                    property alias normalModeConfig: normalModeConfig
                    property alias letterCaseBox: letterCaseBox
                    height: column.height

                    property alias availableLangs: langs.languages

                    LanguageList {
                        id: langs
                    }

                    Column {
                        id: column
                        spacing: 10
                        width: dialogActivityConfig.width
                        height: dialogActivityConfig.height

                        GCDialogCheckBox {
                            id: normalModeConfig
                            width: column.width - 50
                            text: qsTr("All words")
                            checked: (items.currentMode === items.normalModeWordCount) ? true : false
                            exclusiveGroup: configOptions
                        }

                        GCDialogCheckBox {
                            id: easyModeConfig
                            width: column.width - 50
                            text: qsTr("Only 5 words")
                            checked: (items.currentMode === items.easyModeWordCount) ? true : false
                            exclusiveGroup: configOptions
                        }

                        Flow {
                            spacing: 5
                            width: dialogActivityConfig.width
                            GCComboBox {
                                id: letterCaseBox
                                label: qsTr("Select case for letter to be searched")
                                background: dialogActivityConfig
                                model: [
                                    {"text": qsTr("Mixed Case"), "value": Font.MixedCase},
                                    {"text": qsTr("Upper Case"), "value": Font.AllUppercase},
                                    {"text": qsTr("Lower Case"), "value": Font.AllLowercase}
                                ]
                                currentText: model[items.currentLetterCase].text
                                currentIndex: items.currentLetterCase
                            }
                        }

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
                if(dataToSave && dataToSave["savedMode"]) {
                    items.currentMode = dataToSave["savedMode"] === "5" ? items.easyModeWordCount : items.normalModeWordCount
                }

                if(dataToSave && dataToSave["savedLetterCase"]) {
                    items.currentLetterCase = dataToSave["savedLetterCase"]
                }

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

                var oldMode = items.currentMode
                items.currentMode = dialogActivityConfig.loader.item.easyModeConfig.checked ? items.easyModeWordCount : items.normalModeWordCount

                var oldLetterCase = items.currentLetterCase
                items.currentLetterCase = dialogActivityConfig.loader.item.letterCaseBox.model[dialogActivityConfig.loader.item.letterCaseBox.currentIndex].value

                dataToSave = {"locale": newLocale, "savedMode": items.currentMode, "savedLetterCase": items.currentLetterCase}

                background.locale = newLocale;

                // Restart the activity with new information
                if(oldLocale !== newLocale || oldMode !== items.currentMode || oldLetterCase !== items.currentLetterCase) {
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
            interval: 100
            Component.onCompleted: {
                win.connect(Activity.nextSubLevel);
            }
        }

        Item {
            id: planeText
            width: plane.width
            height: plane.height
            x: -width
            anchors.top: parent.top
            anchors.topMargin: 5 * ApplicationInfo.ratio

            Image {
                id: plane
                anchors.centerIn: planeText
                anchors.top: parent.top
                source: Activity.resUrl + "plane.svg"
                sourceSize.height: itemHeight
            }

            GCText {
                id: questionItem

                anchors {
                    right: planeText.right
                    rightMargin: 2 * plane.width / 3
                    verticalCenter: planeText.verticalCenter
                    bottomMargin: 10 * ApplicationInfo.ratio
                }
                fontSize: hugeSize
                font.weight: Font.DemiBold
                color: "#2a2a2a"
                text: items.question
            }

            PropertyAnimation {
                id: animateX
                target: planeText
                properties: "x"
                from: -planeText.width
                //to:background.width/2 - planeText.width/2
                to: bar.level <= 2 ? background.width/3.7 : background.width
                duration: bar.level <= 2 ? 5500: 11000
                //easing.type: Easing.OutQuad
                easing.type: bar.level <= 2 ? Easing.OutQuad: Easing.OutInCirc
            }
        }

        BarButton {
            id: repeatItem
            source: "qrc:/gcompris/src/core/resource/bar_repeat.svg"
            sourceSize.width: 80 * ApplicationInfo.ratio
            anchors {
                top: parent.top
                right: parent.right
                margins: 10
            }
            onClicked:{
                Activity.playLetter(Activity.currentLetter);
                animateX.restart();
            }
        }

        Keys.onPressed: {
            if(event.key === Qt.Key_Space) {
                wordsView.currentItem.select()
            }
        }
        Keys.onReleased: {
            keyboardMode = true
            event.accepted = false
        }
        Keys.onEnterPressed: wordsView.currentItem.select();
        Keys.onReturnPressed: wordsView.currentItem.select();
        Keys.onRightPressed: wordsView.moveCurrentIndexRight();
        Keys.onLeftPressed: wordsView.moveCurrentIndexLeft();
        Keys.onDownPressed: wordsView.moveCurrentIndexDown();
        Keys.onUpPressed: wordsView.moveCurrentIndexUp();

        ListModel {
            id: wordsModel
        }

        property int itemWidth: Math.min(parent.width / 7.5, parent.height / 6.5)
        property int itemHeight: itemWidth * 1.11

        GridView {
            id: wordsView
            anchors.bottom: bar.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: planeText.bottom
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.leftMargin: 15 * ApplicationInfo.ratio
            anchors.rightMargin: 15 * ApplicationInfo.ratio
            anchors.bottomMargin: 10 * ApplicationInfo.ratio
            cellWidth: itemWidth + 25 * ApplicationInfo.ratio
            cellHeight: itemHeight + 15 * ApplicationInfo.ratio
            clip: false
            interactive: false
            //verticalLayoutDirection: GridView.BottomToTop
            layoutDirection: Qt.LeftToRight

            keyNavigationWraps: true
            model: wordsModel
            delegate: Card {
                width: background.itemWidth
                Connections {
                    target: bonus
                    onStart: {
                        mouseActive = false;
                    }
                    onStop: {
                        mouseActive = true;
                    }
                }
            }

            highlight: Rectangle {
                width: wordsView.cellWidth - wordsView.spacing
                height: wordsView.cellHeight - wordsView.spacing
                color:  "#AAFFFFFF"
                border.width: 3
                border.color: "black"
                visible: background.keyboardMode
                Behavior on x { SpringAnimation { spring: 2; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 2; damping: 0.2 } }
            }
        }

        BarButton {
            id: ok
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: wordsView.cellWidth*0.8
            height: width
            sourceSize.width: wordsView.cellWidth
            anchors {
                right: parent.right
                rightMargin: 3 * ApplicationInfo.ratio
                bottom: wordsView.bottom
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Activity.checkAnswer();
                }
            }
        }

        JsonParser {
            id: parser
            onError: console.error("Click_on_letter: Error parsing JSON: " + msg);
        }

        Loader {
            id: englishFallbackDialog
            sourceComponent: GCDialog {
                parent: activity.main
                message: qsTr("We are sorry, we don't have yet a translation for your language.") + " " +
                         qsTr("GCompris is developed by the KDE community, you can translate GCompris by joining a translation team on <a href=\"%2\">%2</a>").arg("https://l10n.kde.org/") +
                         "<br /> <br />" +
                         qsTr("We switched to English for this activity but you can select another language in the configuration dialog.")
                onClose: background.englishFallback = false
            }
            anchors.fill: parent
            focus: true
            active: background.englishFallback
            onStatusChanged: if (status == Loader.Ready) item.start()
        }
    }
}
