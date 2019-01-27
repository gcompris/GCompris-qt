/* GCompris - readingh.qml
 *
 * Copyright (C) 2015 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Johnny Jazeix <jazeix@gmail.com> (Qt Quick port)
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
import GCompris 1.0

import "../../core"
import "readingh.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    /* mode of the activity, "readingh" (horizontal) or "readingv" (vertical):*/
    property string mode: "readingh"

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: Activity.url + "reading-bg.svg"
        signal start
        signal stop
        sourceSize.width: parent.width
        fillMode: Image.Stretch

        Component.onCompleted: {
            dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // system locale by default
        property string locale: "system"

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias wordlist: wordlist
            property alias wordDropTimer: wordDropTimer
            property alias locale: background.locale
            property alias iAmReady: iAmReady
            property alias answerButtonFound: answerButtonFound
            property alias answerButtonNotFound: answerButtonNotFound
            property alias answerButtonsFlow: answerButtonsFlow
            property alias wordDisplayRepeater: wordDisplayRepeater
            property string textToFind
            property int currentIndex
            property bool buttonsBlocked: false
        }

        onStart: { Activity.start(items, mode) }
        onStop: { Activity.stop() }

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

            onClose: home()
            onLoadData: {
                if(dataToSave) {
                    if(dataToSave["locale"]) {
                        background.locale = dataToSave["locale"];
                    }
                }
            }
            onSaveData: {
                var oldLocale = background.locale;
                var newLocale = dialogActivityConfig.configItem.availableLangs[dialogActivityConfig.loader.item.localeBox.currentIndex].locale;
                // Remove .UTF-8
                if(newLocale.indexOf('.') !== -1) {
                    newLocale = newLocale.substring(0, newLocale.indexOf('.'))
                }
                dataToSave = {
                    "locale": newLocale,
                }

                background.locale = newLocale;
                // Restart the activity with new information
                if(oldLocale !== newLocale) {
                    background.stop();
                    wordDisplayList.layoutDirection = Core.isLeftToRightLocale(background.locale) ? Qt.LeftToRight : Qt.RightToLeft;
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
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | config }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onConfigClicked: {
                dialogActivityConfig.active = true
                dialogActivityConfig.setDefaultValues()
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            // Do not pass automatically at next level, allowing the child to do more than one try, or add sublevels?
            Component.onCompleted: {
                win.connect(resetClickInProgress)
                loose.connect(resetClickInProgress)
            }
        }

        function resetClickInProgress() {
            items.buttonsBlocked = false
            Activity.initLevel()
        }

        Flow {
            id: wordDisplayList
            spacing: 20
            x: 70/800*parent.width
            y: 100/600*parent.height - 40 * ApplicationInfo.ratio
            width: 350/800*parent.width-x
            height: 520/600*parent.height-y - 40 * ApplicationInfo.ratio
            flow: mode == "readingh" ? Flow.LeftToRight : Flow.TopToBottom
            layoutDirection: Core.isLeftToRightLocale(locale) ? Qt.LeftToRight : Qt.RightToLeft

            Repeater {
                id: wordDisplayRepeater
                model: Activity.words
                property int idToHideBecauseOverflow: 0
                delegate: GCText {
                    text: modelData
                    color: "#373737"
                    opacity: iAmReady.visible ? false : (index == items.currentIndex ? 1 : 0)

                    onOpacityChanged: {
                    /* Handle case where we go over the image
                    On these cases, we hide all above items to restart to 0
                    As we don't replay the same level and always replace the model,
                    we do not care about restoring visible to true */
                        if((x+width > wordDisplayList.width) ||
                           (y+height > wordDisplayList.height)) {
                            var i = wordDisplayRepeater.idToHideBecauseOverflow;
                            for(; i < index; ++i) {
                                wordDisplayRepeater.itemAt(i).visible=false
                            }
                            wordDisplayRepeater.idToHideBecauseOverflow = i
                        }
                    }
                }
            }
        }

        GCText {
            id: wordToFindBox
            x: 430/800*parent.width
            y: 90/600*parent.height
            text: qsTr("<font color=\"#373737\">Check if the word<br/></font><b><font color=\"#315AAA\">%1</font></b><br/><font color=\"#373737\">is displayed</font>").arg(items.textToFind)
            color: "#373737"
            horizontalAlignment: Text.AlignHCenter
            width: background.width/3
            height: background.height/5
            fontSizeMode: Text.Fit
        }

        ReadyButton {
            id: iAmReady
            onClicked: Activity.run()
            x: background.width / 2
            y: background.height / 2.2
            anchors.verticalCenter: undefined
            anchors.horizontalCenter: undefined
            theme: "light"
        }
        Flow {
            id: answerButtonsFlow
            x: iAmReady.x
            y: iAmReady.y
            width: wordToFindBox.width
            AnswerButton {
                id : answerButtonFound
                width: Math.min(250 * ApplicationInfo.ratio, background.width/2-10)
                height: 60 * ApplicationInfo.ratio
                textLabel: qsTr("Yes, I saw it!")
                isCorrectAnswer: Activity.words ? Activity.words.indexOf(items.textToFind) != -1 : false
                onCorrectlyPressed: bonus.good("flower")
                onIncorrectlyPressed: bonus.bad("flower")
                blockAllButtonClicks: items.buttonsBlocked
                onPressed: {
                    items.buttonsBlocked = true
                }
            }

            AnswerButton {
                id : answerButtonNotFound
                width: Math.min(250 * ApplicationInfo.ratio, background.width/2-10)
                height: 60 * ApplicationInfo.ratio
                textLabel: qsTr("No, it was not there!")
                isCorrectAnswer: !answerButtonFound.isCorrectAnswer
                onCorrectlyPressed: bonus.good("flower")
                onIncorrectlyPressed: bonus.bad("flower")
                blockAllButtonClicks: items.buttonsBlocked
                onPressed: {
                    items.buttonsBlocked = true
                }
            }
        }

        Wordlist {
            id: wordlist
            defaultFilename: Activity.dataSetUrl + "default-en.json"
            // To switch between locales: xx_XX stored in configuration and
            // possibly correct xx if available (ie fr_FR for french but dataset is fr.)
            useDefault: false
            filename: ""

            onError: console.log("Reading: Wordlist error: " + msg);
        }

        Timer {
            id: wordDropTimer
            repeat: true
            interval: 1000
            onTriggered: Activity.dropWord();
        }

    }

}
