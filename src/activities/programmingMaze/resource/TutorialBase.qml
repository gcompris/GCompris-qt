/* GCompris - TutorialBase.qml
 *
 * SPDX-FileCopyrightText: 2021 Timothée Giet <animtim@gcompris.net>
 *
 * Authors:
 *   Timothée Giet <animtim@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "../../../core"
import "../"
import "../programmingMaze.js" as Activity

Image {
    id: tutorialBase
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit
    source: "qrc:/gcompris/src/activities/programmingMaze/resource/background-pm.svg"
    readonly property int levelNumber: items.currentLevel
    property string activeAreaTuto: "instruction"
    property bool instructionTextVisible
    property bool mainVisible: false
    property bool procedureVisible: false
    property bool loopVisible: false

    Item {
        id: layoutTuto
        width: parent.paintedWidth
        height: parent.paintedHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        property int buttonWidth: width / 10
        property int buttonHeight: height / 15.3
        property int stepX: layoutTuto.width / 10
        property int stepY: (layoutTuto.height - layoutTuto.height / 10) / 10

        Repeater {
            id: mazeModelTuto
            anchors.left: layoutTuto.left
            anchors.top: layoutTuto.top
            model: items.levels[levelNumber].map

            Image {
                id: iceBlockTuto
                x: modelData.x * width
                y: modelData.y * height
                width: layoutTuto.stepX
                height: layoutTuto.stepY
                source: Activity.reverseCountUrl + "ice-block.svg"
            }
        }

        Image {
            id: fishTuto
            width: layoutTuto.width / 12
            sourceSize.width: width
            source: Activity.reverseCountUrl + "fish-blue.svg"
            x: items.levels[levelNumber].fish.x * layoutTuto.stepX + (layoutTuto.stepX - width) / 2
            y: items.levels[levelNumber].fish.y * layoutTuto.stepY + (layoutTuto.stepY - height) / 2
        }

        Image {
            id: playerTuto
            source: "qrc:/gcompris/src/activities/maze/resource/tux_top_south.svg"
            width: fishTuto.width
            sourceSize.width: width
            rotation: 270
            x: items.levels[levelNumber].map[0].x * layoutTuto.stepX + (layoutTuto.stepX - width) / 2
            y: items.levels[levelNumber].map[0].y * layoutTuto.stepY + (layoutTuto.stepY - height) / 2
        }

        Rectangle {
            id: activeCodeAreaTuto
            color: "#1dade4"
            opacity: 0.5
            radius: 8 * ApplicationInfo.ratio
            border.width: 2 * ApplicationInfo.ratio
            border.color: "white"
            anchors.fill: activeAreaTuto === "instruction" ? instructionAreaTuto :
                            ( activeAreaTuto === "main" ? wholeMainArea : wholeProcedureArea)
        }

        GridView {
            id: instructionAreaTuto
            width: layoutTuto.width * 0.5
            height: layoutTuto.height * 0.17
            cellWidth: layoutTuto.buttonWidth
            cellHeight: layoutTuto.buttonHeight

            anchors.left: layoutTuto.left
            anchors.top: mazeModelTuto.bottom
            anchors.topMargin: layoutTuto.height * 0.4

            interactive: false
            model: instructionModel
            header: HeaderArea {
                width: instructionAreaTuto.width
                height: layoutTuto.height / 11
                radius: 4 * ApplicationInfo.ratio
                headerOpacity: 1
                headerText: instructionArea.instructionText
            }

            delegate: Item {
                    id: instructionItemTuto
                    width: layoutTuto.buttonWidth
                    height: layoutTuto.buttonHeight * 1.18

                    Rectangle {
                        id: imageHolderTuto
                        width: parent.width - 1 * ApplicationInfo.ratio
                        height: parent.height - 1 * ApplicationInfo.ratio
                        border.width: 1.2 * ApplicationInfo.ratio
                        border.color: "#2a2a2a"
                        anchors.centerIn: parent
                        radius: width / 18
                        color: "#ffffff"

                        Image {
                            id: iconTuto
                            source: Activity.url + name + ".svg"
                            width: Math.round(parent.width / 1.2)
                            height: Math.round(parent.height / 1.2)
                            sourceSize.width: height
                            sourceSize.height: height
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                        }
                    }
            }
        }

        ListModel {
            id: mainFunctionModelTuto1
            ListElement {
                name: "move-forward"
            }
        }

        ListModel {
            id: mainFunctionModelTuto2
            ListElement {
                name: "call-procedure"
            }
        }

        ListModel {
            id: mainFunctionModelTuto3
            ListElement {
                name: "execute-loop"
            }
        }

        ListModel {
            id: procedureModelTuto
            ListElement {
                name: "move-forward"
            }
            ListElement {
                name: "move-forward"
            }
            ListElement {
                name: "turn-right"
            }
        }

        HeaderArea {
            id: mainFunctionHeaderTuto
            headerText: mainFunctionHeader.headerText
            headerOpacity: activeAreaTuto === "main" ? 1 : 0.5
            width: parent.width * 0.4
            height: parent.height / 10
            radius: 4 * ApplicationInfo.ratio
            anchors.top: layoutTuto.top
            anchors.right: layoutTuto.right
            visible: mainVisible
        }

        GridView {
            id: mainFunctionCodeAreaTuto
            visible: mainVisible
            width: parent.width * 0.4
            height: parent.height * 0.29
            cellWidth: layoutTuto.buttonWidth
            cellHeight: layoutTuto.buttonHeight

            anchors.right: parent.right
            anchors.top: mainFunctionHeaderTuto.bottom

            interactive: false
            model: activeAreaTuto === "procedure" ? mainFunctionModelTuto2 : (activeAreaTuto === "loop" ? mainFunctionModelTuto3 : mainFunctionModelTuto1)

            delegate: Item {
                    id: mainItemTuto
                    width: layoutTuto.buttonWidth
                    height: layoutTuto.buttonHeight

                    Rectangle {
                        width: parent.width - 1 * ApplicationInfo.ratio
                        height: parent.height - 1 * ApplicationInfo.ratio
                        border.width: 1.2 * ApplicationInfo.ratio
                        border.color: "#2a2a2a"
                        anchors.centerIn: parent
                        radius: width / 18
                        color: "#ffffff"

                        Image {
                            source: Activity.url + name + ".svg"
                            width: Math.round(parent.width / 1.2)
                            height: Math.round(parent.height / 1.2)
                            sourceSize.width: height
                            sourceSize.height: height
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                        }
                    }
            }
        }

        Item {
            id: wholeMainArea
            width: mainFunctionHeaderTuto.width
            height: mainFunctionHeaderTuto.height + mainFunctionCodeAreaTuto.height
            anchors.top: mainFunctionHeaderTuto.top
            anchors.left: mainFunctionHeaderTuto.left
        }

        HeaderArea {
            id: procedureHeaderTuto
            headerText: procedureHeader.headerText
            headerIcon: procedureHeader.headerIcon
            headerOpacity: 1
            width: parent.width * 0.4
            height: parent.height / 10
            radius: 4 * ApplicationInfo.ratio
            visible: procedureVisible || loopVisible
            anchors.top: mainFunctionCodeAreaTuto.bottom
            anchors.right: parent.right
        }

        Item {
            id: loopCounterTuto
            visible: loopVisible
            width: layoutTuto.buttonWidth * 3
            height: layoutTuto.buttonHeight
            anchors.top: procedureHeaderTuto.bottom
            anchors.horizontalCenter: procedureHeaderTuto.horizontalCenter

            Rectangle {
                id: decreaseButton
                width: parent.width * 0.3
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: 1.2 * ApplicationInfo.ratio
                border.width: 1.2 * ApplicationInfo.ratio
                border.color: "grey"
                radius: decreaseButton.width * 0.1

                GCText {
                    id: decreaseSign
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    color: "#373737"
                    text: Activity.LoopEnumValues.MINUS_SIGN
                }
            }

            Rectangle {
                id: loopCounter
                width: parent.width * 0.3
                height: parent.height
                anchors.left: decreaseButton.right
                anchors.leftMargin: 1.2 * ApplicationInfo.ratio
                border.width: 1.2 * ApplicationInfo.ratio
                border.color: "grey"
                radius: loopCounter.width * 0.1

                GCText {
                    id: loopCounterText
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    color: "#373737"
                    text: "1"
                }
            }

            Rectangle {
                id: increaseButton
                width: parent.width * 0.3
                height: parent.height
                anchors.left: loopCounter.right
                anchors.leftMargin: 1.2 * ApplicationInfo.ratio
                border.width: 1.2 * ApplicationInfo.ratio
                border.color: "grey"
                radius: increaseButton.width * 0.1

                GCText {
                    id: increaseSign
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    wrapMode: Text.WordWrap
                    color: "#373737"
                    text: Activity.LoopEnumValues.PLUS_SIGN
                }
            }
        }

        GridView {
            id: procedureCodeAreaTuto
            visible: procedureVisible || loopVisible
            width: parent.width * 0.4
            height: parent.height * 0.29
            cellWidth: layoutTuto.buttonWidth
            cellHeight: layoutTuto.buttonHeight

            anchors.right: parent.right
            anchors.top: loopVisible ? loopCounterTuto.bottom : procedureHeaderTuto.bottom

            interactive: false
            model: procedureModelTuto

            delegate: Item {
                    id: procedureItemTuto
                    width: layoutTuto.buttonWidth
                    height: layoutTuto.buttonHeight

                    Rectangle {
                        width: parent.width - 1 * ApplicationInfo.ratio
                        height: parent.height - 1 * ApplicationInfo.ratio
                        border.width: 1.2 * ApplicationInfo.ratio
                        border.color: "#2a2a2a"
                        anchors.centerIn: parent
                        radius: width / 18
                        color: "#ffffff"

                        Image {
                            source: Activity.url + name + ".svg"
                            width: Math.round(parent.width / 1.2)
                            height: Math.round(parent.height / 1.2)
                            sourceSize.width: height
                            sourceSize.height: height
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            mipmap: true
                        }
                    }
            }
        }

        Item {
            id: wholeProcedureArea
            width: procedureHeaderTuto.width
            height: procedureHeaderTuto.height + procedureCodeAreaTuto.height
            anchors.top: procedureHeaderTuto.top
            anchors.left: procedureHeaderTuto.left
        }

        Rectangle {
            id: highlightArea
            color: "#00000000"
            border.width: 3 * ApplicationInfo.ratio
            border.color: "#E63B3B"
            anchors.fill: activeAreaTuto === "instruction" ? instructionAreaTuto :
                            ( activeAreaTuto === "main" ? wholeMainArea : wholeProcedureArea)
            scale: 1.05
        }

        Rectangle {
            id: constraintInstructionTuto
            anchors.left: parent.left
            anchors.top: instructionAreaTuto.bottom
            anchors.topMargin: 5 * ApplicationInfo.ratio
            width: parent.width / 2.3
            height: parent.height / 8.9
            radius: 5
            z: 3
            color: "#E8E8E8" //paper white
            border.width: 1 * ApplicationInfo.ratio
            border.color: "#87A6DD"  //light blue
            visible: instructionTextVisible

            GCText {
                id: instructionTextTuto
                anchors.fill: parent
                anchors.margins: parent.border.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap

                text: instructionText.text
            }
        }

        Item {
            id: runCodeLayout
            height: constraintInstructionTuto.height
            anchors.left: constraintInstructionTuto.right
            anchors.right: mainFunctionCodeAreaTuto.left
            anchors.verticalCenter: constraintInstructionTuto.verticalCenter

            Image {
                id: runCode
                height: Math.min(parent.width, parent.height)
                width: height
                sourceSize.width: height
                sourceSize.height: height
                anchors.centerIn: parent
                source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

    }
}
