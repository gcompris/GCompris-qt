/* GCompris - Frieze.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno ANSELME <be.root@free.fr>
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
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

    pageComponent: Image {
        id: background
        source: "qrc:/gcompris/src/activities/crane/resource/background.svg"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.height: height
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

            property var levels: activity.datasets
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

            property alias instruction: instruction
            property alias file: file
            property bool buttonsBlocked: false

            function toggleReady() {
                solution.visible = !solution.visible
                readyButton.enabled = solution.visible
                tokens.visible = !tokens.visible
            }
        }
        property int baseMargins: 10 * ApplicationInfo.ratio
        property int baseSizeValue: 60 * ApplicationInfo.ratio

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

        Rectangle {
            id: instructionArea
            opacity: 1
            radius: background.baseMargins
            color: "#373737"
            height: 40 * ApplicationInfo.ratio
            width: Math.min(320 * ApplicationInfo.ratio, parent.width - 2 * background.baseMargins)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: background.baseMargins

            GCText {
                id: instruction
                wrapMode: TextEdit.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                height: parent.height - background.baseMargins
                width: parent.width - 2 * background.baseMargins
                fontSizeMode: Text.Fit
                color: 'white'
                anchors.centerIn: instructionArea
            }
        }

        Item {
            id: layoutArea
            anchors.top: instructionArea.bottom
            anchors.bottom: okButton.top
            anchors.left: background.left
            anchors.right: background.right
            anchors.margins: background.baseMargins
        }

        Item {
            id: referenceArea // used to calculate the ideal token and flow size for solution and answer
            width: layoutArea.width - background.baseMargins
            height: (layoutArea.height - 5 * background.baseMargins) * 0.33
            property int tokenSize: Math.floor(Math.min(Core.fitItems(width, height, solutionModel.count), background.baseSizeValue))
        }

        Rectangle {
            id: solutionRect
            width: solution.childrenRect.width + background.baseMargins
            height: solution.childrenRect.height + background.baseMargins
            anchors.top: layoutArea.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#E9E9E9"
            radius: background.baseMargins
            Flow {
                id: solution
                width: referenceArea.width
                height: referenceArea.height
                anchors.top: parent.top
                anchors.topMargin: background.baseMargins * 0.5
                anchors.left: parent.left
                anchors.leftMargin: anchors.topMargin
                layoutDirection: (Core.isLeftToRightLocale(ApplicationSettings.locale)) ?  Qt.LeftToRight : Qt.RightToLeft
                Repeater {
                    model: solutionModel
                    delegate: TokenFrieze {
                        width: referenceArea.tokenSize
                    }
                }
            }

        }

        Rectangle {
            id: answerRect
            width: answer.childrenRect.width + background.baseMargins
            height: answer.childrenRect.height + background.baseMargins
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: solutionRect.bottom
            anchors.topMargin: background.baseMargins
            color: "#E9E9E9"
            radius: background.baseMargins
            Flow {
                id: answer
                width: referenceArea.width
                height: referenceArea.height
                anchors.top: parent.top
                anchors.topMargin: background.baseMargins * 0.5
                anchors.left: parent.left
                anchors.leftMargin: anchors.topMargin
                layoutDirection: (Core.isLeftToRightLocale(ApplicationSettings.locale)) ?  Qt.LeftToRight : Qt.RightToLeft
                Repeater {
                    model: answerModel
                    delegate: TokenFrieze {
                        width: referenceArea.tokenSize
                    }
                }
            }

            ErrorRectangle {
                id: errorRectangle
                anchors.fill: parent
                radius: background.baseMargins
                imageSize: parent.height * 0.75
                function releaseControls() {
                    items.buttonsBlocked = false;
                }
            }
        }

        Item {
            id: controlsArea
            width: layoutArea.width
            height: referenceArea.height
            anchors.top: answerRect.bottom
            anchors.topMargin: background.baseMargins
            anchors.horizontalCenter: parent.horizontalCenter
            Item {
                id: tokensArea
                width: parent.width - background.baseSizeValue * 2 - background.baseMargins * 2
                height: parent.height
                property int tokenSize: Math.floor(Math.min(Core.fitItems(width, height, tokensModel.count), background.baseSizeValue))
            }
            Rectangle {
                id: tokensRect
                width: tokens.contentItem.childrenRect.width + background.baseMargins
                height: tokens.contentItem.childrenRect.height + background.baseMargins
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#E9E9E9"
                radius: background.baseMargins
                enabled: !items.buttonsBlocked
                GridView {
                    id: tokens
                    width: tokensArea.width
                    height: tokensArea.height
                    cellWidth: tokensArea.tokenSize
                    cellHeight: tokensArea.tokenSize
                    anchors.top: parent.top
                    anchors.topMargin: background.baseMargins * 0.5
                    anchors.left: parent.left
                    anchors.leftMargin: anchors.topMargin
                    boundsBehavior: Flickable.StopAtBounds
                    maximumFlickVelocity: activity.height
                    keyNavigationWraps: true
                    enabled: (items.currentAnswer < answerModel.count)
                    opacity: (enabled || items.buttonsBlocked) ? 1.0 : 0.3
                    model: tokensModel
                    delegate: TokenFrieze {
                        width: tokensArea.tokenSize
                    }
                    highlightMoveDuration: 0
                    highlight: Rectangle {
                        color: "#00FFFFFF"
                        radius: height * 0.1
                        border.color: "#80373737"
                        border.width: 2 * ApplicationInfo.ratio
                    }
                }
                TokenFrieze {       // Animated token visible during drops
                    id: animationToken
                    width: tokensArea.tokenSize
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

            GCButton {
                id: readyButton
                width: Math.min(2 * background.baseSizeValue, tokensRect.width)
                height: Math.min(background.baseSizeValue, tokensRect.height)
                anchors.centerIn: tokensRect
                text: qsTr("I am Ready")
                opacity: (!enabled) ? 0.0 : 1.0
                theme: "dark"
                MouseArea {
                    anchors.fill: parent
                    onClicked: items.toggleReady()
                    enabled: !items.buttonsBlocked
                }
            }

            Image {
                id: hintButton
                source: "qrc:/gcompris/src/core/resource/bar_hint.svg"
                smooth: true
                width: background.baseSizeValue
                height: background.baseSizeValue
                sourceSize.width: background.baseSizeValue
                sourceSize.height: background.baseSizeValue
                fillMode: Image.PreserveAspectFit
                anchors.right: tokensRect.left
                anchors.rightMargin: background.baseMargins
                anchors.verticalCenter: tokensRect.verticalCenter
                enabled: !solution.visible
                opacity: (!enabled) ? 0.0 : 1.0
                MouseArea {
                    anchors.fill: parent
                    onClicked: items.toggleReady()
                    enabled: !items.buttonsBlocked
                }
            }

            Image {
                id: cancelButton
                source: enabled ? "qrc:/gcompris/src/core/resource/cancel.svg" : "qrc:/gcompris/src/core/resource/cancel_disabled.svg"
                smooth: true
                width: background.baseSizeValue
                height: background.baseSizeValue
                sourceSize.width: background.baseSizeValue
                sourceSize.height: background.baseSizeValue
                fillMode: Image.PreserveAspectFit
                anchors.left: tokensRect.right
                anchors.leftMargin: background.baseMargins
                anchors.verticalCenter: tokensRect.verticalCenter
                enabled: (items.currentAnswer > 0) && (!readyButton.enabled)
                MouseArea {
                    anchors.fill: parent
                    enabled: !items.buttonsBlocked
                    onClicked: Activity.cancelDrop()
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

        BarButton {
            id: okButton
            anchors.right: score.left
            anchors.rightMargin: background.baseMargins
            anchors.verticalCenter: score.verticalCenter
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: background.baseSizeValue
            height: background.baseSizeValue
            sourceSize.height: background.baseSizeValue
            sourceSize.width: background.baseSizeValue
            onClicked: Activity.checkResult()
            visible: (items.currentAnswer === answerModel.count)
            mouseArea.enabled: !items.buttonsBlocked
        }

        Score {
            id: score
            numberOfSubLevels: items.subLevelCount
            currentSubLevel: items.currentSubLevel
            anchors.top: undefined
            anchors.bottom: background.bottom
            anchors.bottomMargin: bar.height * 1.5
            anchors.right: background.right
            anchors.rightMargin: background.baseMargins
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
