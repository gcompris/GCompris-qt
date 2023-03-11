/* GCompris - GrammarAnalysis.qml
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import GCompris 1.0

import "../../core"
import "grammar_analysis.js" as Activity
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    property string grammarMode: "_analysis"            // Modified for grammar_classes
    readonly property bool translationMode: false       // Set this value to true to activate translator's mode

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        source: Activity.dataUrl + "background.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        signal start
        signal stop

        // system locale by default
        property string locale: "system"

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item activityPage: activity
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias locale: background.locale
            // Qml models
            property alias syntaxModel: syntaxModel
            property alias datasetModel: datasetModel
            property alias goalModel: goalModel
            property alias answerModel: answerModel
            // Qml main items
            property alias flow: flow
            property alias rowAnswer: rowAnswer
            property alias rowGoalTokens: rowGoalTokens
            // Activity parameters
            property int selectedClass: 0
            property int selectedBox: 0
            property int currentExercise: 0
            property alias objective: objective
            property bool keysOnTokens: true                // True when focus is on grammatical tokens else if focus is on words
            property var boxIndexes: []                     // Array of pairs <word number>-<subclass number (box)>
            property int animDuration: 500                  // Duration for swing, vanish and moveto animations
            property alias okButton: okButton
            property alias file: file
            property alias jsonParser: jsonParser
            property alias errors: errors
            //--- Debug properties
            property bool debugActive: false
            property alias inspector: inspector
            property alias phrase: phrase
            property alias response: response
            property string goalStr: ""
            property string translationFile: ""             // Display translation file's basename
            //--- End of debug properties
        }

        onStart: { Activity.start(items, grammarMode, translationMode) }
        onStop: { Activity.stop() }

        File {
            id: file
            onError: console.error("File error: " + msg)
        }

        JsonParser {
            id: jsonParser
            onError: errors.text = msg.replace(/invalid\:/,'invalid<br>')
        }

        ListModel { id: syntaxModel }
        ListModel { id: goalModel }
        ListModel { id: answerModel }
        ListModel {
            id: datasetModel
            function randPosition() {                       // choose a random position
                return (Math.floor(Math.random() * count))
            }
            function shuffleModel() {                       // shuffle exercises
                for (var i = 0 ; i < count; i++) {
                    move(randPosition(), randPosition(), 1)
                }
            }
        }

        // Tutorial section
        Image {
            id: tutorialScreen
            source: "qrc:/gcompris/src/activities/braille_alphabets/resource/intro_bg.svg"
            anchors.fill: parent
            visible: true
            Tutorial {
                id: tutorialSection
                useImage: false
                tutorialDetails: Activity.tutorialInstructions[grammarMode]
                onSkipPressed: {
                    Activity.initLevel()
                    tutorialScreen.visible = false
                }
            }
        }

        // Main section
        Rectangle {
            id: mainArea
            anchors.top: parent.top
            anchors.bottom: bar.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 5
            visible: !tutorialScreen.visible
            color: "transparent"
            Column {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: 5
                anchors.topMargin: 50
                spacing: 30
                GCText {        // Exercise's objective
                    id: objective
                    fontSize: regularSize
                    width: parent.width - 50
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    wrapMode: Text.WordWrap
                }
                Rectangle {     // Display grammatical classes (goal)
                    color: "beige"
                    border.color: "burlywood"
                    border.width: items.keysOnTokens  ? 5 : 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: rowGoalTokens.height + 24
                    width: rowGoalTokens.width + 24
                    radius: 7
                    focus: true
                    z: 2
                    Row {
                        id: rowGoalTokens
                        spacing: 5
                        anchors.centerIn: parent
                        layoutDirection: (Core.isLeftToRightLocale(items.locale)) ?  Qt.LeftToRight : Qt.RightToLeft
                        Repeater {
                            model: goalModel
                            delegate: GrammarToken {
                                classCode: code
                                className: wordClass
                                svgName: image
                            }
                        }
                    }
                }
                Rectangle {     // Display sentence
                    color: "beige"
                    border.color: "burlywood"
                    border.width: !items.keysOnTokens  ? 5 : 0
                    width: flow.width + 15
                    height: flow.height + 15
                    anchors.margins: 5
                    radius: 7
                    Flow {
                        id: flow
                        width: background.width - 50
                        spacing: 0
                        leftPadding: 10
                        rightPadding: 10
                        anchors.verticalCenter: parent.verticalCenter
                        layoutDirection: (Core.isLeftToRightLocale(items.locale)) ?  Qt.LeftToRight : Qt.RightToLeft
                        Repeater {
                            id: rowAnswer
                            model: answerModel
                            delegate: WordAndClass {
                                expected: code
                                wordText: word
                                proposition: prop
                                startPos: startCount
                            }
                        }
                    }
                }
                GCText {        // Error text
                    id: errors
                    color: "red"
                    fontSize: tinySize
                    anchors.horizontalCenter:  parent.horizontalCenter
                }
            }
        }

        DialogChooseLevel {
            id: dialogActivityConfig
            currentActivity: activity.activityInfo

            onSaveData: {
                levelFolder = dialogActivityConfig.chosenLevels
                currentActivity.currentLevels = dialogActivityConfig.chosenLevels
                ApplicationSettings.setCurrentLevels(currentActivity.name, dialogActivityConfig.chosenLevels)
            }
            onLoadData: {
                if(activityData && activityData["locale"]) {
                    background.locale = Core.resolveLocale(activityData["locale"]);
                }
                else {
                    background.locale = Core.resolveLocale(background.locale);
                }
            }
            onClose: {
                home()
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
            content: BarEnumContent { value: tutorialScreen.visible ? help | home : help | home | level | activityConfig }
            onHelpClicked: displayDialog(dialogHelp)
            onActivityConfigClicked: displayDialog(dialogActivityConfig)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        BarButton {
            id: okButton
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 60 * ApplicationInfo.ratio
            visible: !tutorialScreen.visible
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 20
            sourceSize.width: width
            onClicked: Activity.checkResult()
            mouseArea.enabled: !bonus.isPlaying
        }

        Score {
            id: score
            numberOfSubLevels: items.datasetModel.count
            currentSubLevel: items.currentExercise + 1
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: undefined
            anchors.bottom: undefined
            visible: !tutorialScreen.visible
            margins: 0
            scale: 0.6
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Keys.onPressed: Activity.handleKeys(event)

        //--- Debugging zone.
        Text {
            id: hideDebug
            text: "Alt+Left and Alt+Right to change exercise\nCtrl+Alt+Return to flip debug informations"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            visible: translationMode
        }
        Column {
            id: infoView
            anchors.top: score.bottom
            visible: items.debugActive
            spacing: 5
            Text {
                width: 200
                height: 80
                text: "Activity: %1\nLocale: %2\nTranslation file: %3\nExercise: %4/%5\nGoal: %6".arg(activityInfo.title).arg(items.locale).arg(items.translationFile).arg(items.currentExercise + 1).arg(datasetModel.count).arg(items.goalStr)
            }
            Text {
                id: phrase
                width: 200
                height: 16
            }
            Text {
                id: response
                width: 200
                height: 16
            }
        }

        Rectangle {
            id: inspector
            property alias message: msg.text
            property bool shown: false
            anchors.top: parent.top
            anchors.left: parent.left
            width: shown ? msg.contentWidth + 10 : 70
            height: shown ? msg.contentHeight + 4 : 18
            color: "white"
            opacity: 0.5
            radius: 5
            visible: items.debugActive
            Text {
                id: msg
                anchors.fill: parent
                text: "Debug area"
                clip: true
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: { parent.shown = !parent.shown }
                onEntered: { inspector.opacity = 1.0 }
                onExited: { inspector.opacity = 0.5 }
            }
        }
        //--- End of debugging zone.
    }
}
