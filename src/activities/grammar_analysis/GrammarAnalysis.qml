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
pragma ComponentBehavior: Bound

import QtQuick 2.12
import core 1.0

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
        id: activityBackground
        source: "qrc:/gcompris/src/activities/guesscount/resource/backgroundW01.svg"
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
            property alias activityBackground: activityBackground
            property int currentLevel: activity.currentLevel
            property alias bonus: bonus
            property alias locale: activityBackground.locale
            property alias score: score
            property alias goodAnswerSound: goodAnswerSound
            property alias badAnswerSound: badAnswerSound
            property bool buttonsBlocked: false
            // Qml models
            property alias syntaxModel: syntaxModel
            property alias datasetModel: datasetModel
            property alias goalModel: goalModel
            property alias answerModel: answerModel
            // Qml main items
            property alias wordsFlow: wordsFlow
            property alias rowAnswer: rowAnswer
            property alias gridGoalTokens: gridGoalTokens
            property alias errorRectangle: errorRectangle
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

        onStart: { Activity.start(items, activity.grammarMode, activity.translationMode) }
        onStop: { Activity.stop() }

        GCSoundEffect {
            id: goodAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/completetask.wav"
        }

        GCSoundEffect {
            id: badAnswerSound
            source: "qrc:/gcompris/src/core/resource/sounds/crash.wav"
        }

        File {
            id: file
            onError: (msg) => console.error("File error: " + msg)
        }

        JsonParser {
            id: jsonParser
            onError: (msg) => errors.text = msg.replace(/invalid\:/,'invalid<br>')
        }

        ListModel { id: syntaxModel }
        ListModel { id: goalModel }
        ListModel { id: answerModel }
        ListModel {
            id: datasetModel
            function randPosition(): int {                       // choose a random position
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
                tutorialDetails: Activity.tutorialInstructions[activity.grammarMode]
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
                    required property string wordClass
                    text: wordClass
                }
            }
        }

        // Main section
        Item {
            id: mainArea
            anchors.top: parent.top
            anchors.bottom: scoreButtonContainer.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: GCStyle.baseMargins
            visible: !tutorialScreen.visible
            Column {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height
                spacing: GCStyle.baseMargins
                Rectangle {
                    id: objectiveContainer
                    width: objective.contentWidth + GCStyle.baseMargins * 2
                    height: objective.contentHeight + GCStyle.baseMargins
                    color: GCStyle.darkBg
                    radius: GCStyle.tinyMargins
                    border.width: GCStyle.thinnestBorder
                    border.color: GCStyle.lightBorder
                    anchors.horizontalCenter: parent.horizontalCenter
                    GCText {        // Exercise's objective
                        id: objective
                        color: GCStyle.lightText
                        fontSize: regularSize
                        fontSizeMode: Text.Fit
                        width: mainArea.width - GCStyle.baseMargins * 2
                        height: Math.min((mainArea.height - GCStyle.baseMargins * 3) * 0.2, 60 * ApplicationInfo.ratio)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.WordWrap
                    }
                }
                Rectangle {     // Display grammatical classes (goal)
                    id: goalTokensContainer
                    color: GCStyle.lightBg
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: gridGoalTokens.width + GCStyle.baseMargins
                    height: gridGoalTokens.height + GCStyle.baseMargins
                    radius: GCStyle.tinyMargins
                    focus: true
                    z: 2
                    Rectangle {
                        z: -1
                        color: GCStyle.blueBorder
                        radius: GCStyle.tinyMargins
                        visible: items.keyboardNavigation && items.keysOnTokens
                        anchors.centerIn: parent
                        width: parent.width + GCStyle.baseMargins
                        height: parent.height + GCStyle.baseMargins
                    }
                    Grid {
                        id: gridGoalTokens
                        anchors.centerIn: parent
                        columns: mainArea.width / tokenWidth
                        layoutDirection: (Core.isLeftToRightLocale(items.locale)) ?  Qt.LeftToRight : Qt.RightToLeft

                        property real tokenWidth: Math.max(GCStyle.bigButtonHeight, tokenTextSizeRef.width)
                        property real tokenHeight: columns < goalModel.count ? 40 * ApplicationInfo.ratio : 60 * ApplicationInfo.ratio

                        Repeater {
                            model: goalModel
                            delegate: GrammarToken {
                                width: gridGoalTokens.tokenWidth
                                height: gridGoalTokens.tokenHeight
                                required property string code
                                required property string wordClass
                                required property string image
                                required property int index
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
                    height: mainArea.height - objectiveContainer.height - goalTokensContainer.height - GCStyle.baseMargins * 2

                    property real itemHeight: Math.min(40 * ApplicationInfo.ratio, height * 0.2)
                    property bool isSmallHeight: itemHeight < 30 * ApplicationInfo.ratio

                    Rectangle {     // Display sentence
                        color: GCStyle.lightBg
                        width: parent.width
                        height: wordsFlow.height
                        radius: GCStyle.tinyMargins
                        Rectangle {
                            z: -1
                            color: GCStyle.blueBorder
                            radius: GCStyle.tinyMargins
                            visible: items.keyboardNavigation && !items.keysOnTokens
                            anchors.centerIn: parent
                            width: parent.width + GCStyle.baseMargins
                            height: parent.height + GCStyle.baseMargins
                        }
                        Flow {
                            id: wordsFlow
                            width: parent.width - GCStyle.baseMargins * 2
                            spacing: 0
                            leftPadding: GCStyle.halfMargins
                            rightPadding: GCStyle.halfMargins
                            anchors.verticalCenter: parent.verticalCenter
                            layoutDirection: (Core.isLeftToRightLocale(items.locale)) ?  Qt.LeftToRight : Qt.RightToLeft
                            Repeater {
                                id: rowAnswer
                                model: answerModel
                                delegate: WordAndClass {
                                    required property string code
                                    required property string word
                                    required property string prop
                                    required property int startCount
                                    expected: code
                                    wordText: word
                                    proposition: prop
                                    startPos: startCount
                                    isSmallHeight: wordsArea.isSmallHeight
                                }
                            }
                        }
                        ErrorRectangle {
                            id: errorRectangle
                            anchors.fill: parent
                            radius: parent.radius
                            imageSize: okButton.width
                            function releaseControls() { items.buttonsBlocked = false; }
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
            MouseArea {
                // used to block all mouse input on activity interface execpt the OK button
                anchors.fill: parent
                enabled: items.buttonsBlocked
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
                    activityBackground.locale = Core.resolveLocale(activityData["locale"]);
                }
                else {
                    activityBackground.locale = Core.resolveLocale(activityBackground.locale);
                }
            }
            onClose: {
                activity.home()
            }
            onStartActivity: {
                activityBackground.start()
            }
        }
        DialogHelp {
            id: dialogHelp
            onClose: activity.home()
        }

        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: tutorialScreen.visible ? help | home : help | home | level | activityConfig }
            onHelpClicked: activity.displayDialog(dialogHelp)
            onActivityConfigClicked: activity.displayDialog(dialogActivityConfig)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Item {
            id: scoreButtonContainer
            visible: !tutorialScreen.visible
            width: score.width + GCStyle.baseMargins + okButton.width
            height: okButton.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: activityBackground.bottom
            anchors.bottomMargin: 1.5 * bar.height

            BarButton {
                id: okButton
                source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                width: GCStyle.bigButtonHeight
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onClicked: Activity.checkResult()
                mouseArea.enabled: !items.buttonsBlocked
            }

            Score {
                id: score
                numberOfSubLevels: items.datasetModel.count
                currentSubLevel: items.currentExercise
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 0
                anchors.bottom: undefined
                anchors.top: undefined
                anchors.right: undefined
                visible: !tutorialScreen.visible
                onStop: Activity.nextSubLevel()
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }

        // Needed to get keyboard focus on Tutorial
        Keys.forwardTo: [tutorialSection]
        Keys.onPressed: (event) => { Activity.handleKeys(event) }

        //--- Debugging zone.
        Text {
            id: hideDebug
            text: "Alt+Left and Alt+Right to change exercise\nCtrl+Alt+Return to flip debug informations"
            anchors.top: scoreButtonContainer.bottom
            anchors.right: parent.right
            visible: activity.translationMode
        }
        Column {
            id: infoView
            anchors.bottom: scoreButtonContainer.bottom
            visible: items.debugActive
            spacing: 5
            Text {
                width: 200
                height: 80
                text: "Activity: %1\nLocale: %2\nTranslation file: %3\nExercise: %4/%5\nGoal: %6".arg(activity.activityInfo.title).arg(items.locale).arg(items.translationFile).arg(items.currentExercise + 1).arg(datasetModel.count).arg(items.goalStr)
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
