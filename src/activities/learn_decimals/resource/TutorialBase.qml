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
import QtQuick 2.9
import GCompris 1.0

import "../../../core"
import "../"
import "../learn_decimals.js" as Activity

Image {
    id: tutorialBase
    anchors.fill: parent
    fillMode: Image.PreserveAspectFit
    source: "qrc:/gcompris/src/activities/braille_fun/resource/hillside.svg"

    property bool isRepresentationShown: false
    property bool isResultTyping: false
    property bool isSubtractionMode: false
    property bool isSubtractionMode2: false
    property bool isAdditionMode: false

    Item {
        id: layoutTutorial
        width: parent.paintedWidth
        height: parent.paintedHeight
        anchors.centerIn: parent

        readonly property string largestNumber: Activity.toDecimalLocaleNumber(1.5)
        readonly property string smallestNumber: Activity.toDecimalLocaleNumber(0.3)

        Rectangle {
            id: decimalNumberTutorial
            width: parent.width * 0.6
            height: parent.height / 12
            radius: 10
            color: "#373737"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 2 * ApplicationInfo.ratio
            GCText {
                anchors.centerIn: parent
                width: parent.width - 4 * ApplicationInfo.ratio
                height: parent.height
                text: layoutTutorial.displayQuestion()
                fontSize: smallSize
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.weight: Font.DemiBold
                color: "white"
            }
        }

        function displayQuestion() {
            if(tutorialBase.isSubtractionMode) {
                return decimalNumber.subtractionQuestion.arg(layoutTutorial.largestNumber).arg(layoutTutorial.smallestNumber)
            }
            else if(tutorialBase.isAdditionMode) {
                return decimalNumber.additionQuestion.arg(layoutTutorial.largestNumber).arg(layoutTutorial.smallestNumber)
            }
            else {
                return decimalNumber.decimalQuestion.arg(layoutTutorial.largestNumber)
            }
        }

        Item {
            id: tutoLayoutArea
            anchors.top: decimalNumberTutorial.bottom
            anchors.topMargin: 2 * ApplicationInfo.ratio
            anchors.bottom: okButtonTutorial.top
            anchors.bottomMargin: anchors.topMargin
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.7
        }

        Rectangle {
            id: topRectangleTutorial
            visible: tutorialBase.isSubtractionMode || tutorialBase.isRepresentationShown
            anchors.top: tutoLayoutArea.top
            color: "#F2F2F2"
            border.color: "#373737"
            border.width: 1
            radius: 5

            states: [
                State {
                    when: background.horizontalLayout
                    PropertyChanges {
                        target: topRectangleTutorial
                        width: tutoLayoutArea.width
                        height: tutorialBase.isSubtractionMode ? tutoLayoutArea.height * 0.8 : tutoLayoutArea.height * 0.636
                    }
                    AnchorChanges {
                        target: topRectangleTutorial
                        anchors.right: undefined
                        anchors.horizontalCenter: tutoLayoutArea.horizontalCenter
                    }
                    PropertyChanges {
                        target: firstBar
                        cellSize: tutorialBase.isSubtractionMode ?
                            Math.min(topRectangleTutorial.height / 6, topRectangleTutorial.width / 11) :
                            Math.min(topRectangleTutorial.height / 7, topRectangleTutorial.width / 11)
                        anchors.topMargin: tutorialBase.isSubtractionMode ? firstBar.cellSize * 0.14 :
                            firstBar.cellSize * 0.125
                        anchors.leftMargin: 0
                    }
                    AnchorChanges {
                        target: firstBar
                        anchors.top: topBarsLayout.top
                        anchors.horizontalCenter: topBarsLayout.horizontalCenter
                        anchors.verticalCenter: undefined
                        anchors.left: undefined
                    }
                    PropertyChanges {
                        target: secondBar
                        anchors.topMargin: tutorialBase.isSubtractionMode ? firstBar.cellSize * 0.14 :
                            firstBar.cellSize * 0.125
                        anchors.leftMargin: 0
                    }
                    AnchorChanges {
                        target: secondBar
                        anchors.top: firstBar.bottom
                        anchors.horizontalCenter: topRectangleTutorial.horizontalCenter
                        anchors.verticalCenter: undefined
                        anchors.left: undefined
                    }
                },
                State {
                    when: !background.horizontalLayout && !tutorialBase.isResultTyping
                    PropertyChanges {
                        target: topRectangleTutorial
                        width: tutorialBase.isSubtractionMode ? tutoLayoutArea.width : tutoLayoutArea.width * 0.636
                        height: tutoLayoutArea.height * 0.8
                        anchors.rightMargin: 5 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: topRectangleTutorial
                        anchors.right: tutoLayoutArea.right
                        anchors.horizontalCenter: undefined
                    }
                    PropertyChanges {
                        target: firstBar
                        cellSize: tutorialBase.isSubtractionMode ?
                            Math.min(topRectangleTutorial.width / 6, topRectangleTutorial.height / 11) :
                            Math.min(topRectangleTutorial.width / 7, topRectangleTutorial.height / 11)
                        anchors.topMargin: 0
                        anchors.leftMargin: tutorialBase.isSubtractionMode ? firstBar.cellSize * 0.14 :
                            firstBar.cellSize * 0.125
                    }
                    AnchorChanges {
                        target: firstBar
                        anchors.top: topBarsLayout.top
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: topRectangleTutorial.verticalCenter
                        anchors.left: topBarsLayout.left
                    }
                    PropertyChanges {
                        target: secondBar
                        anchors.topMargin: 0
                        anchors.leftMargin: tutorialBase.isSubtractionMode ? firstBar.cellSize * 0.14 :
                            firstBar.cellSize * 0.125
                    }
                    AnchorChanges {
                        target: secondBar
                        anchors.top: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: topRectangleTutorial.verticalCenter
                        anchors.left: firstBar.right
                    }
                },
                State {
                    when: !background.horizontalLayout && tutorialBase.isResultTyping
                    PropertyChanges {
                        target: topRectangleTutorial
                        width: tutorialBase.isSubtractionMode ? tutoLayoutArea.width : tutoLayoutArea.width * 0.636
                        height: tutoLayoutArea.height * 0.8
                        anchors.rightMargin: 5 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: topRectangleTutorial
                        anchors.right: undefined
                        anchors.horizontalCenter: tutoLayoutArea.horizontalCenter
                    }
                    PropertyChanges {
                        target: firstBar
                        cellSize: tutorialBase.isSubtractionMode ?
                            Math.min(topRectangleTutorial.width / 6, topRectangleTutorial.height / 11) :
                            Math.min(topRectangleTutorial.width / 7, topRectangleTutorial.height / 11)
                        anchors.topMargin: 0
                        anchors.leftMargin: tutorialBase.isSubtractionMode ? firstBar.cellSize * 0.14 :
                            firstBar.cellSize * 0.125
                    }
                    AnchorChanges {
                        target: firstBar
                        anchors.top: topBarsLayout.top
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: topRectangleTutorial.verticalCenter
                        anchors.left: topBarsLayout.left
                    }
                    PropertyChanges {
                        target: secondBar
                        anchors.topMargin: 0
                        anchors.leftMargin: tutorialBase.isSubtractionMode ? firstBar.cellSize * 0.14 :
                            firstBar.cellSize * 0.125
                    }
                    AnchorChanges {
                        target: secondBar
                        anchors.top: undefined
                        anchors.horizontalCenter: undefined
                        anchors.verticalCenter: topRectangleTutorial.verticalCenter
                        anchors.left: firstBar.right
                    }
                }
            ]

            Item {
                id: topBarsLayout
                anchors.centerIn: topRectangleTutorial
                width: background.horizontalLayout ? firstBar.cellSize * 10 :
                        (tutorialBase.isSubtractionMode ? firstBar.cellSize * 6 :
                        firstBar.cellSize * 7)
                height: background.horizontalLayout ? (tutorialBase.isSubtractionMode ?
                        firstBar.cellSize * 6 : firstBar.cellSize * 7) : firstBar.cellSize * 10
            }

            TutorialBar {
                id: firstBar
                model: ["fill","fill","fill","fill","fill","fill","fill","fill","fill","fill"]
            }

            TutorialBar {
                id: secondBar
                cellSize: firstBar.cellSize
                model: tutorialBase.isSubtractionMode2 ?
                ["fill","fill","deleted","deleted","deleted","empty","empty","empty","empty","empty"] :
                tutorialBase.isSubtractionMode ?
                ["fill","fill","fill","fill","fill","empty","empty","empty","empty","empty"] :
                ["fill","fill","fill","fill","fill","fill","fill","fill","none","none"]
            }
        }

        Rectangle {
            id: bottomRectangleTutorial
            visible: !tutorialBase.isSubtractionMode && !tutorialBase.isResultTyping
            color: "#F2F2F2"
            border.color: "#373737"
            border.width: 1
            radius: 5

            states: [
                State {
                    when: background.horizontalLayout
                    PropertyChanges {
                        target: bottomRectangleTutorial
                        width: tutoLayoutArea.width
                        // 3/11 of layoutArea
                        height: tutoLayoutArea.height * 0.273
                        anchors.rightMargin: 0
                        // 0.5/11 of layoutArea
                        anchors.topMargin: tutoLayoutArea.height * 0.045
                    }
                    AnchorChanges {
                        target: bottomRectangleTutorial
                        anchors.top: topRectangleTutorial.bottom
                        anchors.horizontalCenter: tutoLayoutArea.horizontalCenter
                        anchors.right: undefined
                    }
                    PropertyChanges {
                        target: bottomBar
                        cellSize: Math.min(bottomRectangleTutorial.height / 3, bottomRectangleTutorial.width / 11)
                        anchors.verticalCenterOffset: -bottomBar.cellSize * 0.5
                        anchors.horizontalCenterOffset: 0
                    }
                    PropertyChanges {
                        target: arrowTutorial
                        rotation: 0
                        anchors.leftMargin: bottomBar.cellSize * 0.5
                        anchors.topMargin: 0
                    }
                    AnchorChanges {
                        target: arrowTutorial
                        anchors.top: bottomBar.bottom
                        anchors.left: bottomBar.left
                        anchors.right: undefined
                    }
                },
                State {
                    when: !background.horizontalLayout
                    PropertyChanges {
                        target: bottomRectangleTutorial
                        width: tutoLayoutArea.width * 0.273
                        height: tutoLayoutArea.height * 0.8
                        anchors.rightMargin: tutoLayoutArea.width * 0.045
                        anchors.topMargin: 0
                    }
                    AnchorChanges {
                        target: bottomRectangleTutorial
                        anchors.top: tutoLayoutArea.top
                        anchors.horizontalCenter: undefined
                        anchors.right: topRectangleTutorial.left
                    }
                    PropertyChanges {
                        target: bottomBar
                        cellSize: Math.min(bottomRectangleTutorial.width / 3, bottomRectangleTutorial.height / 11)
                        anchors.verticalCenterOffset: 0
                        anchors.horizontalCenterOffset: bottomBar.cellSize * 0.5
                    }
                    PropertyChanges {
                        target: arrowTutorial
                        rotation: 90
                        anchors.leftMargin: 0
                        anchors.topMargin: bottomBar.cellSize * 0.5
                    }
                    AnchorChanges {
                        target: arrowTutorial
                        anchors.top: bottomBar.top
                        anchors.left: undefined
                        anchors.right: bottomBar.left
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
        }

        Rectangle {
            id: answerBackgroundTuto
            visible: tutorialBase.isResultTyping
            width: parent.width * 0.5
            height: parent.height * 0.15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: topRectangleTutorial.bottom
            anchors.topMargin: 5 * ApplicationInfo.ratio
            color: "#f2f2f2"
            border.color: "#373737"
            border.width: 1
            radius: 5

            GCText {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#373737"
                fontSize: smallSize
                text: answerBackground.resultText.arg(" ")
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
                bottomMargin: 5 * ApplicationInfo.ratio
                rightMargin: 5 * ApplicationInfo.ratio
            }
        }
    }
}
