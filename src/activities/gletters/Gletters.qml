/* GCompris - gletters.qml
 *
 * SPDX-FileCopyrightText: 2014 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Holger Kaelberer <holger.k@elberer.de> (Qt Quick port)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "gletters.js" as Activity

ActivityBase {
    id: activity

    // Overload this in your activity to change it
    // Put you default-<locale>.json files in it
    property string dataSetUrl: "qrc:/gcompris/src/activities/gletters/resource/"

    property bool uppercaseOnly: false

    property int speedSetting: 10

    property string activityName: "gletters"

    property bool useDataset: false

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
            readonly property var levels: activity.datasetLoader.data.length !== 0 ? activity.datasetLoader.data : null
            property string instructionText: ""
            property alias background: background
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias wordlist: wordlist
            property alias score: score
            property alias keyboard: keyboard
            property alias wordDropTimer: wordDropTimer
            property GCSfx audioEffects: activity.audioEffects
            property alias locale: background.locale
            property alias textinput: textinput
            property bool inputLocked: false
        }

        onStart: {
            // for smallnumbers and smallnumbers2, we want to have the application locale, not the system one
            if(activity.activityName !== "gletters") {
                var overridenLocale = ApplicationSettings.locale
                // Remove .UTF-8
                if(overridenLocale.indexOf('.') != -1) {
                    overridenLocale = overridenLocale.substring(0, overridenLocale.indexOf('.'))
                }
                background.locale = overridenLocale
            }

            Activity.start(items, uppercaseOnly, mode, speedSetting);
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
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if (activity.activityName === "gletters") {
                    if(activityData && activityData["locale"]) {
                        background.locale = Core.resolveLocale(activityData["locale"]);
                        activity.uppercaseOnly = activityData["uppercaseMode"] === "true" ? true : false;
                    }
                    else {
                        background.locale = Core.resolveLocale(background.locale)
                    }
                } else if (activity.activityName === "smallnumbers2") {
                    if(activityData && activityData["mode"]) {
                        activity.dominoMode = activityData["mode"];
                    }
                }
                if(activityData && activityData["speedSetting"]) {
                    activity.speedSetting = activityData["speedSetting"];
                }
            }
            onStartActivity: {
                background.stop()
                background.start()
            }
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
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
            anchors.right: parent.right
            anchors.rightMargin: 10 * ApplicationInfo.ratio
            anchors.bottom: bar.top
        }

        Connections {
            target: audioVoices
            onDone: {
                // If we have won, we wait until the last voice has played to play the bonus
                if(items.inputLocked && !bonus.isPlaying) {
                    items.bonus.good("lion");
                }
            }
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
