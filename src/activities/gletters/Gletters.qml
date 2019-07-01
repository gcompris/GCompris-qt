/* GCompris - gletters.qml
 *
 * Copyright (C) 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
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
import GCompris 1.0

import "../../core"
import "gletters.js" as Activity

ActivityBase {
    id: activity

    // Overload this in your activity to change it
    // Put you default-<locale>.json files in it
    property string dataSetUrl: "qrc:/gcompris/src/activities/gletters/resource/"
    /* no need to display the configuration button for smallnumbers */
    property bool configurationButtonVisible: true

    property bool uppercaseOnly: false

    property string activityName: "gletters"

    /* mode of the activity, "letter" (gletters) or "word" (wordsgame):*/
    property string mode: "letter"

    // Override if you want to replace texts by your image
    function getImage(key) {
        return ""
    }

    // Override if you want to replace texts by the domino
    function getDominoValues(key) {
        return []
    }

    onStart: focus = true
    onStop: {}

    // When going on configuration, it steals the focus and re set it to the activity.
    // We need to set it back to the textinput item in order to have key events.
    onFocusChanged: {
        if(focus) {
            Activity.focusTextInput()
        }
    }

    pageComponent: Image {
        id: background
        source: activity.dataSetUrl + "background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize.height: parent.height

        signal start
        signal stop

        // system locale by default
        property string locale: "system"
        
        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        QtObject {
            id: items
            property Item main: activity.main
            property Item ourActivity: activity
            property GCAudio audioVoices: activity.audioVoices
            property var levels: activity.datasetLoader.item !== null ? activity.datasetLoader.item.data : null
            property var instructionText: ""
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias wordlist: wordlist
            property alias score: score
            property alias keyboard: keyboard
            property alias wordDropTimer: wordDropTimer
            property GCSfx audioEffects: activity.audioEffects
            property alias locale: background.locale
            property alias textinput: textinput
        }

        onStart: {
            Activity.start(items, uppercaseOnly, mode);
            Activity.focusTextInput()
        }
        onStop: { Activity.stop() }

        //instruction rectangle
        Rectangle {
            id: instruction
            anchors {
                top: parent.top
                topMargin: 5
                horizontalCenter: parent.horizontalCenter
            }
            height: instructionTxt.contentHeight * 1.1
            width: Math.max(Math.min(parent.width * 0.8, instructionTxt.text.length * 10), parent.width * 0.3)
            opacity: 0.8
            visible: items.levels
            radius: 10
            border.width: 2
            z: 10
            border.color: "#DDD"
            color: "#373737"

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                onClicked: instruction.opacity = instruction.opacity == 0 ? 0.8 : 0
            }

            GCText {
                id: instructionTxt
                anchors {
                    top: parent.top
                    topMargin: 5
                    horizontalCenter: parent.horizontalCenter
                }
                opacity: instruction.opacity
                z: instruction.z
                fontSize: smallSize
                color: "white"
                text: items.instructionText
                horizontalAlignment: Text.AlignHCenter
                width: parent.width * 0.8
                wrapMode: TextEdit.WordWrap
            }
        }

        TextInput {
            // Helper element to capture composed key events like french ô which
            // are not available via Keys.onPressed() on linux. Must be
            // disabled on mobile!
            id: textinput
            anchors.centerIn: background
            enabled: !ApplicationInfo.isMobile
            focus: true
            visible: false

            onTextChanged: {
                if (text != "") {
                    Activity.processKeyPress(text);
                    text = "";
                }
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo
            onClose: {
                home()
            }
            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevel
                currentActivity.currentLevel = dialogActivityConfig.chosenLevel
                ApplicationSettings.setCurrentLevel(currentActivity.name, dialogActivityConfig.chosenLevel)
                home()
                background.stop()
                background.start()
            }
            onLoadData: {
                if (activity.activityName == "gletters") {
                    if(activityData && activityData["locale"]) {
                        background.locale = activityData["locale"];
                        activity.uppercaseOnly = activityData["uppercaseMode"] === "true" ? true : false;
                    }
                } else if (activity.activityName == "smallnumbers2") {
                    if(activityData && activityData["mode"]) {
                        activity.dominoMode = activityData["mode"];
                    }
                }
            }
            onStartActivity: {
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }
        
        Bar {
            id: bar
            anchors.bottom: keyboard.top
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            interval: 2000
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
        
        Score {
            id: score
            anchors.top: undefined
            anchors.topMargin: 10 * ApplicationInfo.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: keyboard.top
        }
        
        VirtualKeyboard {
            id: keyboard
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            onKeypress: Activity.processKeyPress(text)
            onError: console.log("VirtualKeyboard error: " + msg);
        }
        
        Wordlist {
            id: wordlist
            defaultFilename: activity.dataSetUrl + "default-en.json"
            // To switch between locales: xx_XX stored in configuration and
            // possibly correct xx if available (ie fr_FR for french but dataset is fr.)
            useDefault: false
            filename: ""

            onError: console.log("Gletters: Wordlist error: " + msg);
        }
        
        Timer {
            id: wordDropTimer
            repeat: false
            onTriggered: Activity.dropWord();
        }

    }

}
