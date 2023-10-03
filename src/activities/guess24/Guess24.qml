/* GCompris - guess24.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 *
 * Authors:
 *   Bruno ANSELME <be.root@free.fr> (Qt Quick native)
 *   Timothée Giet <animtim@gmail.com> (Graphics and layout refactoring)
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * References :
 *  https://www.4nums.com/game/difficulties/
 *  https://www.4nums.com/solutions/allsolvables/   (2023-07-08 datas)
 *  https://fr.y8.com/games/make_24
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "guess24.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"
        signal start
        signal stop

        property int baseMargins: 5 * ApplicationInfo.ratio

        Component.onCompleted: {
            dialogActivityConfig.initialize()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property var levels: activity.datasetLoader.data
            property GCSfx audioEffects: activity.audioEffects
            property alias jsonParser: jsonParser
            property int currentValue: 0
            property int currentOperator: -1
            property int operatorsCount: 4
            property int subLevelCount: 0
            property int currentSubLevel: 0
            property bool keysOnValues: true    // True when focus is on values false if focus is on operators
            property alias cardsModel: cardsModel
            property alias cardsBoard: cardsBoard
            property alias operators: operators
            property alias cancelButton: cancelButton
            property alias hintButton: hintButton
            property alias animationCard: animationCard
            property alias steps: steps
            property alias solution: solution
            property alias solutionRect: solutionRect
            property alias animSol: animSol
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        JsonParser { id: jsonParser }

        ListModel {
            id: cardsModel
            function randPosition() { return (Math.floor(Math.random() * count)) }                                      // choose a random position
            function shuffleModel() { for (var i = 0 ; i < count; i++) { move(randPosition(), randPosition(), 1) } }    // shuffle elements
        }

        GCText {
            id: caption
            anchors.top: background.top
            anchors.left: background.left
            anchors.right: background.right
            anchors.margins: background.baseMargins
            text: qsTr("Use the four numbers with given operators to find 24.")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            MouseArea {
                anchors.fill: parent
                onClicked: caption.opacity = 0.0
            }
        }

        Item {
            id: layoutArea
            anchors.top: caption.bottom
            anchors.bottom: score.top
            anchors.horizontalCenter: background.horizontalCenter
            anchors.margins: background.baseMargins
            width: Math.min(background.width - 2 * background.baseMargins,
                                400 * ApplicationInfo.ratio)
        }
        // Main section
        Rectangle {     // Values
            id: valuesArea
            anchors.top: layoutArea.top
            anchors.left: layoutArea.left
            width: layoutArea.width * 0.66
            height: Math.min(250 * ApplicationInfo.ratio, layoutArea.height * 0.75)
            color: "beige"
            radius: background.baseMargins
            GridView {
                id: cardsBoard
                anchors.fill: parent
                cellWidth: (parent.width - background.baseMargins) * 0.5
                cellHeight: (parent.height - background.baseMargins) * 0.5
                highlightFollowsCurrentItem: false
                boundsBehavior: Flickable.StopAtBounds
                model: cardsModel
                delegate: Item {   // Display a card with a number inside
                    id: cardNumber
                    property int value: value_
                    width: cardsBoard.cellWidth
                    height: cardsBoard.cellHeight
                    Rectangle {
                        id: cardRect
                        width: parent.width - background.baseMargins
                        height: parent.height - background.baseMargins
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: background.baseMargins
                        visible: true
                        color: (items.currentValue === index) ? "peru" :  "burlywood"
                        border.width: 3
                        border.color: (items.keysOnValues && (cardsBoard.currentIndex === index)) ? "black" : "transparent"
                        radius: background.baseMargins
                        GCText {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            fontSize: hugeSize
                            fontSizeMode: Text.Fit
                            text: value
                        }
                        MouseArea {
                            id: boardArea
                            anchors.fill: parent
                            enabled: animationCard.state === ""
                            onClicked: Activity.valueClicked(index)
                        }
                    }
                }
            }

            Rectangle {     // Animation card visible during animations
                id: animationCard
                property string value: ""
                property string action: Activity.animActions[0]
                width: cardsBoard.cellWidth - background.baseMargins
                height: cardsBoard.cellHeight - background.baseMargins
                color: "peru"
                radius: 10
                visible: false
                border.color: "burlywood"
                border.width: 2
                GCText {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSize: hugeSize
                    fontSizeMode: Text.Fit
                    text: animationCard.value
                }
                states: [
                    State {
                        name: "moveto"
                        PropertyChanges {
                            target: animationCard
                            visible: true
                            x: items.cardsBoard.currentItem.x
                            y: items.cardsBoard.currentItem.y
                        }
                    },
                    State {
                        name: "wait"
                        PropertyChanges {
                            target: animationCard
                            visible: true
                            color: "tomato"
                            border.color: "tomato"
                        }
                    }
                ]
                transitions: [
                    Transition {
                        to: "moveto"
                        SequentialAnimation {
                            alwaysRunToEnd: true
                            NumberAnimation { properties: "x,y"; duration: 300 }
                            ScriptAction {
                                script: {
                                    animationCard.state = ""
                                    if (animationCard.action === "forward")
                                        Activity.checkResult()
                                    else if (animationCard.action === "backward")
                                        Activity.endPopOperation()
                                }
                            }
                        }
                    },
                    Transition {
                        to: "wait"
                        SequentialAnimation {
                            alwaysRunToEnd: true
                            PauseAnimation { duration: 800 }
                            ScriptAction { script: { audioEffects.play('qrc:/gcompris/src/core/resource/sounds/crash.wav') } }
                            PauseAnimation { duration: 800 }
                            ScriptAction { script: { Activity.popOperation() }}
                        }
                    }
                ]
            }
        }

        Rectangle {     // Operators
            id: operatorsArea
            anchors.top: valuesArea.bottom
            anchors.topMargin: background.baseMargins
            anchors.left: valuesArea.left
            anchors.right: valuesArea.right
            height: Math.min(layoutArea.height - valuesArea.height - background.baseMargins,
                             80 * ApplicationInfo.ratio)
            radius: background.baseMargins
            color: "beige"
            enabled: ((items.currentValue !== -1) && (animationCard.state === ""))
            ListView {
                id: operators
                anchors.fill: parent
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds
                model: [ "+", "−", "×", "÷" ]
                delegate: Item {
                    width: (operatorsArea.width - background.baseMargins) * 0.25
                    height: operatorsArea.height
                    Rectangle {     // Display an operator button
                        id: opRect
                        width: parent.width - background.baseMargins
                        height: parent.height - background.baseMargins * 2
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.margins: background.baseMargins
                        visible: index < items.operatorsCount
                        color: (items.currentOperator === index) ? "peru" : "burlywood"
                        opacity: (items.currentValue !== -1) ? 1.0 : 0.5
                        border.width: 3
                        border.color: (!items.keysOnValues) && (operators.currentIndex === index) && (items.currentValue !== -1) ? "black" : "transparent"
                        radius: background.baseMargins
                        GCText {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: operators.model[index]
                            fontSize: hugeSize
                            fontSizeMode: Text.Fit
                        }
                        MouseArea {
                            id: opArea
                            anchors.fill: parent
                            onClicked: Activity.operatorClicked(index)
                        }
                    }
                }
            }
        }

        Rectangle {
            id: stepsRect
            width: layoutArea.width - valuesArea.width - background.baseMargins
            height: Math.min(80 * ApplicationInfo.ratio,
                             (layoutArea.height - background.baseMargins) * 0.5)
            anchors.top: layoutArea.top
            anchors.right: layoutArea.right
            color: "beige"
            GCText {
                id: steps
                anchors.fill: parent
                anchors.margins: background.baseMargins
                fontSize: tinySize
                text: ""
            }
        }

        Rectangle {
            id: solutionRect
            width: stepsRect.width
            height: stepsRect.height
            color: "beige"
            anchors.top: stepsRect.bottom
            anchors.topMargin: background.baseMargins
            anchors.right: layoutArea.right
            opacity: 0.0
            GCText {
                id: solution
                anchors.fill: parent
                anchors.margins: background.baseMargins
                fontSize: tinySize
                opacity: 0.5
                text: ""
            }
            NumberAnimation on opacity {
                id: animSol
                property bool firstTime: true
                alwaysRunToEnd: true
                to: 0.0
                duration: 1000
                onStarted: cancelButton.visible = false
                onStopped: {
                    if (!firstTime) {   // animation is triggered on activity start
                        Activity.unstack = true
                        Activity.popOperation()
                    }
                    firstTime = false
                    cardsBoard.enabled = true
                    operators.enabled = true
                }
            }
        }

        Image {
            id: cancelButton
            source: "qrc:/gcompris/src/activities/chess/resource/undo.svg"
            height: score.height
            width: height
            sourceSize.width: width
            sourceSize.height: height
            anchors.top: operatorsArea.bottom
            anchors.topMargin: background.baseMargins
            anchors.left: operatorsArea.left
            enabled: animationCard.state === ""
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (solutionRect.opacity !== 0.0) {
                        animSol.start()
                    } else {
                        animSol.stop()
                        Activity.unstack = false
                        Activity.popOperation()
                    }
                }
            }
        }

        Image {
            id: hintButton
            source: "qrc:/gcompris/src/core/resource/bar_hint.svg"
            height: score.height
            width: height
            sourceSize.width: width
            sourceSize.height: height
            anchors.right: operatorsArea.right
            anchors.top: operatorsArea.bottom
            anchors.topMargin: background.baseMargins
            enabled: animationCard.state === ""
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (Activity.helpCount < 4)
                        Activity.helpCount++
                        solution.text = Activity.splittedSolution.slice(0, Activity.helpCount).join("\n")
                        solutionRect.opacity = 1.0
                        cardsBoard.enabled = false
                        operators.enabled = false
                        hintButton.visible = false
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
            onClose: {
                home()
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

        Score {
            id: score
            numberOfSubLevels: items.subLevelCount
            currentSubLevel: items.currentSubLevel + 1
            anchors.top: undefined
            anchors.right: background.right
            anchors.rightMargin: background.baseMargins
            anchors.left: undefined
            anchors.bottom: background.bottom
            anchors.bottomMargin: bar.height * 1.5
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onActivityConfigClicked: {
                displayDialog(dialogActivityConfig)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextSubLevel)
        }

        Keys.onPressed: Activity.handleKeys(event)
    }
}
