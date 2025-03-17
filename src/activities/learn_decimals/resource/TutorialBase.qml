/* GCompris - TutorialBase.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import core 1.0

import "../../../core"
import "../learn_decimals.js" as Activity

Image {
    id: tutorialBase
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit
    source: "qrc:/gcompris/src/activities/braille_fun/resource/hillside.svg"

    property bool isRepresentationShown: false
    property bool isResultTyping: false
    property bool isSubtractionMode2: false
    property string instructionText: ""
    property string answerText: ""

    Item {
        id: layoutTutorial
        width: parent.paintedWidth
        height: parent.paintedHeight
        anchors.centerIn: parent

        GCTextPanel {
            id: tutorialInstructionPanel
            panelWidth: parent.width - 2 * GCStyle.baseMargins
            panelHeight: Math.min(50 * ApplicationInfo.ratio, parent.height * 0.1)
            fixedHeight: true
            border.width: 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: GCStyle.halfMargins
            textItem.text: tutorialBase.instructionText
        }

        Item {
            id: tutoLayoutArea
            anchors.top: tutorialInstructionPanel.bottom
            anchors.topMargin: GCStyle.tinyMargins
            anchors.bottom: okButtonTutorial.top
            anchors.bottomMargin: anchors.topMargin
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.7
        }

        Rectangle {
            id: topRectangleTutorial
            visible: activity.isSubtractionMode || tutorialBase.isRepresentationShown
            anchors.top: tutoLayoutArea.top
            color: GCStyle.lightBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinnestBorder
            radius: GCStyle.halfMargins

            states: [
                State {
                    when: activityBackground.horizontalLayout
                    PropertyChanges {
                        topRectangleTutorial {
                            width: tutoLayoutArea.width
                            height: activity.isSubtractionMode ? tutoLayoutArea.height * 0.8 : tutoLayoutArea.height * 0.636
                        }
                        firstBar {
                            cellSize: activity.isSubtractionMode ?
                            Math.min(topRectangleTutorial.height / 6, topRectangleTutorial.width / 11) :
                            Math.min(topRectangleTutorial.height / 7, topRectangleTutorial.width / 11)
                        }
                    }
                    AnchorChanges {
                        target: topRectangleTutorial
                        anchors.right: undefined
                        anchors.horizontalCenter: tutoLayoutArea.horizontalCenter
                    }
                },
                State {
                    when: !activityBackground.horizontalLayout && !tutorialBase.isResultTyping
                    PropertyChanges {
                        topRectangleTutorial {
                            width: activity.isSubtractionMode ? tutoLayoutArea.width : tutoLayoutArea.width * 0.636
                            height: tutoLayoutArea.height * 0.8
                            anchors.rightMargin: GCStyle.halfMargins
                        }
                        firstBar {
                            cellSize: activity.isSubtractionMode ?
                            Math.min(topRectangleTutorial.width / 6, topRectangleTutorial.height / 11) :
                            Math.min(topRectangleTutorial.width / 7, topRectangleTutorial.height / 11)
                        }
                    }
                    AnchorChanges {
                        target: topRectangleTutorial
                        anchors.right: tutoLayoutArea.right
                        anchors.horizontalCenter: undefined
                    }
                },
                State {
                    when: !activityBackground.horizontalLayout && tutorialBase.isResultTyping
                    PropertyChanges {
                        topRectangleTutorial {
                            width: activity.isSubtractionMode ? tutoLayoutArea.width : tutoLayoutArea.width * 0.636
                            height: tutoLayoutArea.height * 0.8
                            anchors.rightMargin: GCStyle.halfMargins
                        }
                        firstBar {
                            cellSize: activity.isSubtractionMode ?
                            Math.min(topRectangleTutorial.width / 6, topRectangleTutorial.height / 11) :
                            Math.min(topRectangleTutorial.width / 7, topRectangleTutorial.height / 11)
                        }

                    }
                    AnchorChanges {
                        target: topRectangleTutorial
                        anchors.right: undefined
                        anchors.horizontalCenter: tutoLayoutArea.horizontalCenter
                    }
                }
            ]

            Flow {
                id: topBarsLayout
                anchors.centerIn: topRectangleTutorial
                width: activityBackground.horizontalLayout ? firstBar.cellSize * 10 :
                        (activity.isSubtractionMode ? firstBar.cellSize * 6 :
                        firstBar.cellSize * 7)
                height: activityBackground.horizontalLayout ? (activity.isSubtractionMode ?
                        firstBar.cellSize * 6 : firstBar.cellSize * 7) : firstBar.cellSize * 10
                spacing: activity.isSubtractionMode ? firstBar.cellSize * 0.14 : firstBar.cellSize * 0.125
                padding: activityBackground.horizontalLayout ? spacing : 0

                TutorialBar {
                    id: firstBar
                    cellSize: activity.isSubtractionMode ?
                    Math.min(topRectangleTutorial.height / 6, topRectangleTutorial.width / 11) :
                    Math.min(topRectangleTutorial.height / 7, topRectangleTutorial.width / 11)
                    model: ["fill","fill","fill","fill","fill","fill","fill","fill","fill","fill"]
                }

                TutorialBar {
                    id: secondBar
                    cellSize: firstBar.cellSize
                    model: tutorialBase.isSubtractionMode2 ?
                    ["fill","fill","deleted","deleted","deleted","empty","empty","empty","empty","empty"] :
                    activity.isSubtractionMode ?
                    ["fill","fill","fill","fill","fill","empty","empty","empty","empty","empty"] :
                    activity.isAdditionMode ?
                    ["fill","fill","fill","fill","fill","fill","fill","fill","none","none"] :
                    ["fill","fill","fill","fill","fill","none","none","none","none","none"]
                }
            }
        }

        Rectangle {
            id: bottomRectangleTutorial
            visible: !activity.isSubtractionMode && !tutorialBase.isResultTyping
            color: GCStyle.lightBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinnestBorder
            radius: GCStyle.halfMargins

            states: [
                State {
                    when: activityBackground.horizontalLayout
                    PropertyChanges {
                        bottomRectangleTutorial {
                            width: tutoLayoutArea.width
                            // 3/11 of layoutArea
                            height: tutoLayoutArea.height * 0.273
                            anchors.rightMargin: 0
                            // 0.5/11 of layoutArea
                            anchors.topMargin: tutoLayoutArea.height * 0.045
                        }
                    }
                    AnchorChanges {
                        target: bottomRectangleTutorial
                        anchors.top: topRectangleTutorial.bottom
                        anchors.horizontalCenter: tutoLayoutArea.horizontalCenter
                        anchors.right: undefined
                    }
                    PropertyChanges {
                        bottomBar {
                            cellSize: Math.min(bottomRectangleTutorial.height / 3, bottomRectangleTutorial.width / 11)
                            anchors.verticalCenterOffset: -bottomBar.cellSize * 0.5
                            anchors.horizontalCenterOffset: 0
                        }
                    }
                    PropertyChanges {
                        arrowTutorial {
                            rotation: 0
                            anchors.leftMargin: bottomBar.cellSize * 0.5
                            anchors.topMargin: 0
                        }
                    }
                    AnchorChanges {
                        target: arrowTutorial
                        anchors.top: bottomBar.bottom
                        anchors.left: bottomBar.left
                        anchors.right: undefined
                    }
                    PropertyChanges {
                        redArrow {
                            height: topRectangleTutorial.height * 0.8
                            rotation: 0
                        }
                    }
                    AnchorChanges {
                        target: redArrow
                        anchors.bottom: bottomBar.verticalCenter
                        anchors.horizontalCenter: bottomBar.horizontalCenter
                        anchors.left: undefined
                        anchors.verticalCenter: undefined
                    }
                },
                State {
                    when: !activityBackground.horizontalLayout
                    PropertyChanges {
                        bottomRectangleTutorial {
                            width: tutoLayoutArea.width * 0.273
                            height: tutoLayoutArea.height * 0.8
                            anchors.rightMargin: tutoLayoutArea.width * 0.045
                            anchors.topMargin: 0
                        }
                    }
                    AnchorChanges {
                        target: bottomRectangleTutorial
                        anchors.top: tutoLayoutArea.top
                        anchors.horizontalCenter: undefined
                        anchors.right: topRectangleTutorial.left
                    }
                    PropertyChanges {
                        bottomBar {
                            cellSize: Math.min(bottomRectangleTutorial.width / 3, bottomRectangleTutorial.height / 11)
                            anchors.verticalCenterOffset: 0
                            anchors.horizontalCenterOffset: bottomBar.cellSize * 0.5
                        }
                    }
                    PropertyChanges {
                        arrowTutorial {
                            rotation: 90
                            anchors.leftMargin: 0
                            anchors.topMargin: bottomBar.cellSize * 0.5
                        }
                    }
                    AnchorChanges {
                        target: arrowTutorial
                        anchors.top: bottomBar.top
                        anchors.left: undefined
                        anchors.right: bottomBar.left
                    }
                    PropertyChanges {
                        redArrow {
                            height: topRectangleTutorial.width * 0.5
                            rotation: 90
                        }
                    }
                    AnchorChanges {
                        target: redArrow
                        anchors.bottom: undefined
                        anchors.horizontalCenter: undefined
                        anchors.left: bottomBar.horizontalCenter
                        anchors.verticalCenter: bottomBar.verticalCenter
                    }
                }
            ]

            TutorialBar {
                id: bottomBar
                anchors.centerIn: parent
                model: ["fill","empty","empty","empty","empty","empty","empty","empty","empty","empty"]
            }

            Image {
                id: arrowTutorial
                source: "qrc:/gcompris/src/activities/learn_decimals/resource/arrow.svg"
                width: bottomBar.cellSize
                height: width
                sourceSize.width: width
            }

            Image {
                id: redArrow
                source: "qrc:/gcompris/src/activities/learn_decimals/resource/redArrow.svg"
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                visible: topRectangleTutorial.visible && !activity.isSubtractionMode
            }
        }

        Rectangle {
            id: answerBackgroundTuto
            visible: tutorialBase.isResultTyping
            width: parent.width * 0.5
            height: parent.height * 0.15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: topRectangleTutorial.bottom
            anchors.topMargin: GCStyle.halfMargins
            color: GCStyle.lightBg
            border.color: GCStyle.darkBorder
            border.width: GCStyle.thinnestBorder
            radius: GCStyle.halfMargins

            GCText {
                id: answerTextTuto
                anchors.fill: parent
                anchors.margins: GCStyle.tinyMargins
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: GCStyle.darkText
                fontSize: smallSize
                fontSizeMode: Text.Fit
                text: tutorialBase.answerText
            }
        }

        Image {
            id: okButtonTutorial
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            width: 30 * ApplicationInfo.ratio
            sourceSize.width: width
            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: GCStyle.halfMargins
            }
        }
    }
}
