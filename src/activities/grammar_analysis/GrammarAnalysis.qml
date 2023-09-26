/* GCompris - GrammarAnalysis.qml
 *
 * Copyright (C) 2022-2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *   Timothée Giet <animtim@gmail.com> (Graphics and layout refactoring)
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
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
        sourceSize.width: width
        sourceSize.height: height
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        signal start
        signal stop

        // system locale by default
        property string locale: "system"
        property int baseMargins: 10 * ApplicationInfo.ratio
        property int baseRadius: 2 * ApplicationInfo.ratio
        property string selectionColor: "#A1CBD9"

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
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias locale: background.locale
            // Qml models
            property alias syntaxModel: syntaxModel
            property alias datasetModel: datasetModel
            property alias goalModel: goalModel
            property alias answerModel: answerModel
            // Qml main items
            property alias wordsFlow: wordsFlow
            property alias rowAnswer: rowAnswer
            property alias gridGoalTokens: gridGoalTokens
            // Activity parameters
            property int selectedClass: 0
            property int selectedBox: 0
            property int currentExercise: 0
            property alias objective: objective
            property bool keyboardNavigation: false
            property bool keysOnTokens: true                // True when focus is on grammatical tokens else if focus is on words
            property var boxIndexes: []                     // Array of pairs <word number>-<subclass number (box)>
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
            source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
            anchors.fill: parent
            sourceSize.width: width
            sourceSize.height: height
            fillMode: Image.PreserveAspectCrop
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

        Column { // invisible column to get longest word from the class names
            id: tokenTextSizeRef
            visible: false
            width: childrenRect.width
            Repeater {
                model: goalModel
                delegate: GCText {
                    fontSize: tinySize
                    text: wordClass
                }
            }
        }

        // Main section
        Item {
            id: mainArea
            anchors.top: parent.top
            anchors.bottom: okButton.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: background.baseMargins
            visible: !tutorialScreen.visible
            Column {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height
                spacing: background.baseMargins
                Rectangle {
                    id: objectiveContainer
                    width: objective.paintedWidth + background.baseMargins * 2
                    height: objective.paintedHeight + background.baseMargins
                    color: "#80FFFFFF"
                    radius: background.baseRadius
                    anchors.horizontalCenter: parent.horizontalCenter
                    GCText {        // Exercise's objective
                        id: objective
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        width: mainArea.width - background.baseMargins * 2
                        height: mainArea.height * 0.2 - background.baseMargins
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WordWrap
                    }
                }
                Rectangle {     // Display grammatical classes (goal)
                    id: goalTokensContainer
                    color: "#F0F0F0"
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: gridGoalTokens.width + background.baseMargins
                    height: gridGoalTokens.height + background.baseMargins
                    radius: background.baseRadius
                    focus: true
                    z: 2
                    Rectangle {
                        z: -1
                        color: background.selectionColor
                        radius: background.baseRadius
                        visible: items.keyboardNavigation && items.keysOnTokens
                        anchors.centerIn: parent
                        width: parent.width + background.baseMargins
                        height: parent.height + background.baseMargins
                    }
                    Grid {
                        id: gridGoalTokens
                        anchors.centerIn: parent
                        columns: mainArea.width / tokenWidth
                        layoutDirection: (Core.isLeftToRightLocale(items.locale)) ?  Qt.LeftToRight : Qt.RightToLeft

                        property real tokenWidth: Math.max(75 * ApplicationInfo.ratio, tokenTextSizeRef.width)
                        property real tokenHeight: columns < goalModel.count ? 40 * ApplicationInfo.ratio : 60 * ApplicationInfo.ratio

                        Repeater {
                            model: goalModel
                            delegate: GrammarToken {
                                width: gridGoalTokens.tokenWidth
                                height: gridGoalTokens.tokenHeight
                                classCode: code
                                className: wordClass
                                svgName: image
                            }
                        }
                    }
                }
                Item {
                    id: wordsArea
                    width: mainArea.width
                    height: mainArea.height - objectiveContainer.height - goalTokensContainer.height - background.baseMargins * 2

                    property real itemHeight: Math.min(40 * ApplicationInfo.ratio, height * 0.2)
                    property bool isSmallHeight: itemHeight < 30 * ApplicationInfo.ratio

                    Rectangle {     // Display sentence
                        color: "#F0F0F0"
                        width: parent.width
                        height: wordsFlow.height
                        radius: background.baseRadius
                        Rectangle {
                            z: -1
                            color: background.selectionColor
                            radius: background.baseRadius
                            visible: items.keyboardNavigation && !items.keysOnTokens
                            anchors.centerIn: parent
                            width: parent.width + background.baseMargins
                            height: parent.height + background.baseMargins
                        }
                        Flow {
                            id: wordsFlow
                            width: parent.width - background.baseMargins * 2
                            spacing: 0
                            leftPadding: background.baseMargins
                            rightPadding: background.baseMargins
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
                        style: Text.Outline
                        styleColor: "white"
                        fontSize: tinySize
                        anchors.horizontalCenter:  parent.horizontalCenter
                    }
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
            level: items.currentLevel + 1
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
            anchors.bottom: background.bottom
            anchors.rightMargin: background.baseMargins
            anchors.bottomMargin: 1.5 * bar.height
            sourceSize.width: width
            onClicked: Activity.checkResult()
            mouseArea.enabled: !bonus.isPlaying
        }

        Score {
            id: score
            numberOfSubLevels: items.datasetModel.count
            currentSubLevel: items.currentExercise + 1
            anchors.right: okButton.left
            anchors.rightMargin: background.baseMargins
            anchors.verticalCenter: okButton.verticalCenter
            anchors.bottom: undefined
            anchors.top: undefined
            anchors.left: undefined
            visible: !tutorialScreen.visible
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
            anchors.top: okButton.bottom
            anchors.right: parent.right
            visible: translationMode
        }
        Column {
            id: infoView
            anchors.bottom: okButton.bottom
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
