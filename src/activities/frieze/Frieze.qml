/* GCompris - Frieze.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-License-Identifier: GPL-3.0-or-later
 *
 * References : https://del-en-maternelle.fr/les-domaines/maths/les-algorithmes/
 *              https://irem.univ-nantes.fr/wp-content/uploads/2019/12/Algorithmes.pdf
 */
import QtQuick 2.12
import GCompris 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core
import "frieze.js" as Activity

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

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bonus: bonus
            property alias score: score
            property GCSfx audioEffects: activity.audioEffects

            property var levels: activity.datasetLoader.data
            property int subLevelCount: 0
            property int currentLevel: activity.currentLevel
            property int currentSubLevel: 0
            property alias solution: solution
            property alias answer: answer
            property alias tokens: tokens
            property alias solutionModel: solutionModel
            property alias answerModel: answerModel
            property alias tokensModel: tokensModel
            property int currentAnswer: 0
            property alias currentToken: tokens.currentIndex
            property alias animationToken: animationToken
            property alias readyButton: readyButton
            property alias errorRectangle: errorRectangle

            property alias caption: caption
            property alias file: file
            property bool buttonsBlocked: false

            function toggleReady() {
                solution.visible = !solution.visible
                readyButton.enabled = solution.visible
                tokens.visible = !tokens.visible
            }
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        ListModel { id: solutionModel }
        ListModel { id: answerModel }
        ListModel {
            id: tokensModel
            function randPosition() { return (Math.floor(Math.random() * count)) }                                      // choose a random position
            function shuffleModel() { for (var i = 0 ; i < count; i++) { move(randPosition(), randPosition(), 1) } }    // shuffle elements
        }

        File {
            id: file
            onError: console.error("File error: " + msg)
        }

        GCText {
            id: caption
            anchors.top: background.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 20
            text: ""
            fontSize: regularSize
        }
        Column {
            width: parent.width
            anchors.top: caption.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            spacing: 40
            Rectangle {
                id: solutionRect
                property int cellSize: Activity.tokenSize + solution.spacing
                property int totalSize: cellSize * solutionModel.count
                property int countPerLine: Math.floor(parent.width / cellSize)
                property int carry: (solutionModel.count % countPerLine) ? 1 : 0
                width: ((totalSize) < parent.width) ? totalSize : countPerLine * cellSize
                height: cellSize * (Math.floor(solutionModel.count / countPerLine) + carry)
                anchors.horizontalCenter: parent.horizontalCenter
                color: "beige"
                radius: 10
                Flow {
                    id: solution
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 10
                    layoutDirection: (Core.isLeftToRightLocale(ApplicationSettings.locale)) ?  Qt.LeftToRight : Qt.RightToLeft
                    Repeater {
                        model: solutionModel
                        delegate: TokenFrieze {}
                    }
                }
            }

            Rectangle {
                width: solutionRect.width
                height: solutionRect.height
                anchors.horizontalCenter: parent.horizontalCenter
                color: "beige"
                radius: 10
                Flow {
                    id: answer
                    spacing: 10
                    anchors.margins: 5
                    anchors.fill: parent
                    layoutDirection: (Core.isLeftToRightLocale(ApplicationSettings.locale)) ?  Qt.LeftToRight : Qt.RightToLeft
                    Repeater {
                        model: answerModel
                        delegate: TokenFrieze {}
                    }
                }

                ErrorRectangle {
                    id: errorRectangle
                    anchors.fill: parent
                    imageSize: 60 * ApplicationInfo.ratio
                    function releaseControls() {
                        items.buttonsBlocked = false;
                    }
                }
            }

            Item {
                width: parent.width
                height: Activity.tokenSize
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    id: tokensRect
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: (Activity.tokenSize + solution.spacing) * tokensModel.count
                    height: Activity.tokenSize + solution.spacing
                    color: "beige"
                    radius: 10
                    enabled: !items.buttonsBlocked
                    ListView {
                        id: tokens
                        anchors.fill: parent
                        anchors.margins: 5
                        orientation: ListView.Horizontal
                        boundsBehavior: Flickable.StopAtBounds
                        spacing: 10
                        enabled: (items.currentAnswer < answerModel.count)
                        opacity: (enabled || items.buttonsBlocked) ? 1.0 : 0.3
                        model: tokensModel
                        delegate: TokenFrieze {}
                        highlightMoveDuration: 0
                        highlight: Rectangle {
                            color: "transparent"
                            radius: 10
                            border.color: "burlywood"
                            border.width: 4
                        }
                    }
                    TokenFrieze {       // Animated token visible during drops
                        id: animationToken
                        content: Activity.emptyToken
                        animated: true
                        clickable: false
                        shown: true
                        visible:false
                        z: 10
                        states: [
                            State {
                                name: "moveto"
                                PropertyChanges {
                                    target: animationToken
                                    visible: true
                                    x: tokens.mapFromItem(answer.children[items.currentAnswer], 0, 0).x
                                    y: tokens.mapFromItem(answer.children[items.currentAnswer], 0, 0).y
                                }
                            }
                        ]
                        transitions: [
                            Transition {
                                to: "moveto"
                                SequentialAnimation {
                                    alwaysRunToEnd: true
                                    SmoothedAnimation { properties: "x,y"; duration: 300 }
                                    ScriptAction {
                                        script: {   // End of moveto
                                            animationToken.state = ""
                                            answerModel.setProperty(items.currentAnswer, "content_", animationToken.content)
                                            tokens.currentItem.opacity = 1.0
                                            items.currentAnswer++
                                            items.buttonsBlocked = false
                                        }
                                    }
                                }
                            }
                        ]
                    }
                }
                Image {
                    id: hintButton
                    source: "qrc:/gcompris/src/core/resource/bar_hint.svg"
                    smooth: true
                    width: 80
                    height: 100
                    sourceSize.width: width
                    sourceSize.height: height
                    fillMode: Image.PreserveAspectFit
                    anchors.right: tokensRect.left
                    anchors.rightMargin: 30
                    enabled: !solution.visible
                    opacity: (!enabled) ? 0.0 : 1.0
                    MouseArea {
                        anchors.fill: parent
                        onClicked: items.toggleReady()
                        enabled: !items.buttonsBlocked
                    }
                }
                GCButton {
                    id: readyButton
                    width: 150
                    height: 100
                    anchors.right: tokensRect.left
                    anchors.rightMargin: 30
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("I am Ready")
                    opacity: (!enabled) ? 0.0 : 1.0
                    MouseArea {
                        anchors.fill: parent
                        onClicked: items.toggleReady()
                        enabled: !items.buttonsBlocked
                    }
                }
                Image {
                    id: cancelButton
                    anchors.left: tokensRect.right
                    source: enabled ? "qrc:/gcompris/src/core/resource/cancel.svg" : "qrc:/gcompris/src/core/resource/cancel_disabled.svg"
                    smooth: true
                    width: 80
                    height: 100
                    sourceSize.width: width
                    sourceSize.height: height
                    fillMode: Image.PreserveAspectFit
                    anchors.leftMargin: 30
                    enabled: (items.currentAnswer > 0) && (!readyButton.enabled)
                    MouseArea {
                        anchors.fill: parent
                        enabled: !items.buttonsBlocked
                        onClicked: Activity.cancelDrop()
                    }
                }
                BarButton {
                    id: okButton
                    source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
                    width: 100
                    anchors.left: cancelButton.right
                    anchors.leftMargin: 20
                    sourceSize.width: width
                    onClicked: Activity.checkResult()
                    visible: (items.currentAnswer === answerModel.count)
                    mouseArea.enabled: !items.buttonsBlocked
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
            currentSubLevel: items.currentSubLevel
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: undefined
            anchors.bottom: undefined
            anchors.topMargin: 10
            anchors.rightMargin: 10
            margins: 0
            onStop: {
                Activity.nextSubLevel()
            }
        }
        Bar {
            id: bar
            level: items.currentLevel + 1
            content: BarEnumContent { value: help | home | level | activityConfig }
            onHelpClicked: displayDialog(dialogHelp)
            onActivityConfigClicked: displayDialog(dialogActivityConfig)
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
            onStop: (items.solution.visible = !items.levels[items.currentLevel].hidden)
        }

        Keys.onPressed: Activity.handleKeys(event)
    }
}
