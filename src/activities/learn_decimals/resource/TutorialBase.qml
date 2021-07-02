/* GCompris - TutorialBase.qml
 *
 * SPDX-FileCopyrightText: 2021 Mariam Fahmy <mariamfahmy66@gmail.com>
 *
 * Authors:
 *   Mariam Fahmy <mariamfahmy66@gmail.com>
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

    property bool isRepresentationShown
    property bool isResultTyping
    property bool isSubtractionMode
    property bool isAdditionMode

    Item {
        id: layoutTutorial
        width: parent.paintedWidth
        height: parent.paintedHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        readonly property string largestNumber: Activity.toDecimalLocaleNumber(1.5)
        readonly property string smallestNumber: Activity.toDecimalLocaleNumber(0.5)

        GCText {
           id: decimalNumberTutorial
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.top: parent.top
           anchors.topMargin: 2 * ApplicationInfo.ratio
           text: layoutTutorial.displayQuestion()
           fontSize: smallSize
           horizontalAlignment: Text.AlignHCenter
           wrapMode: Text.WordWrap
           font.weight: Font.DemiBold
           style: Text.Outline
           styleColor: "black"
           color: "white"
        }

        function displayQuestion() {
            if(tutorialBase.isSubtractionMode) {
                return qsTr("Display the result of: %1 - %2").arg(layoutTutorial.largestNumber).arg(layoutTutorial.smallestNumber)
            }
            else if(tutorialBase.isAdditionMode) {
                return qsTr("Display the result of: %1 + %2").arg(layoutTutorial.largestNumber).arg(layoutTutorial.smallestNumber)
            }
            else {
                return qsTr("Display the number: %1").arg(layoutTutorial.largestNumber)
            }
        }

        Rectangle {
            id: topRectangleTutorial
            visible: tutorialBase.isSubtractionMode || tutorialBase.isRepresentationShown
            anchors.topMargin: 5 * ApplicationInfo.ratio
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 10

            states: [
                State {
                    when: background.horizontalLayout
                    PropertyChanges {
                        target: topRectangleTutorial
                        width: parent.width * 0.6
                        height: tutorialBase.isSubtractionMode ? parent.height * 0.6 : parent.height * 0.4
                        anchors.topMargin: 5 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: topRectangleTutorial
                        anchors.top: decimalNumberTutorial.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                },
                State {
                    when: !background.horizontalLayout
                    PropertyChanges {
                        target: topRectangleTutorial
                        width: tutorialBase.isSubtractionMode ? parent.width * 0.6 : parent.width * 0.4
                        height: parent.height * 0.6
                        anchors.topMargin: 5 * ApplicationInfo.ratio
                        anchors.rightMargin: 60 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: topRectangleTutorial
                        anchors.top: decimalNumberTutorial.bottom
                        anchors.right: tutorialBase.isSubtractionMode ? undefined : parent.right
                        anchors.horizontalCenter: (tutorialBase.isSubtractionMode || isResultTyping) ? parent.horizontalCenter : undefined
                    }
                }
            ]

            RowRepresent {
                id: firstRow
                anchors.top: parent.top
                anchors.topMargin: 15 * ApplicationInfo.ratio
                isFirstRow: true
                model: 10
            }

            RowRepresent {
                id: secondRow
                anchors.top: firstRow.bottom
                anchors.topMargin: tutorialBase.isSubtractionMode ? 10 * ApplicationInfo.ratio : 0
                isFirstRow: false
                model: (!tutorialBase.isAdditionMode && !tutorialBase.isSubtractionMode) ? 5 : 10
            }

            ColumnRepresent {
                id: firstColumn
                anchors.left: parent.left
                anchors.leftMargin: 15 * ApplicationInfo.ratio
                isFirstColumn: true
                model: 10
            }

            ColumnRepresent {
                id: secondColumn
                anchors.left: firstColumn.right
                anchors.leftMargin: tutorialBase.isSubtractionMode ? 15 * ApplicationInfo.ratio : 0
                isFirstColumn: false
                model: (!tutorialBase.isAdditionMode && !tutorialBase.isSubtractionMode) ? 5 : 10
            }
        }

        Rectangle {
            id: bottomRectangleTutorial
            visible: !tutorialBase.isSubtractionMode && !tutorialBase.isResultTyping
            color: "#55333333"
            border.color: "black"
            border.width: 2
            radius: 10

            states: [
                State {
                    when: background.horizontalLayout
                    PropertyChanges {
                        target: bottomRectangleTutorial
                        width: parent.width * 0.6
                        height: parent.height * 0.2
                        anchors.topMargin: 5 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: bottomRectangleTutorial
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: topRectangleTutorial.bottom
                    }
                },
                State {
                    when: !background.horizontalLayout
                    PropertyChanges {
                        target: bottomRectangleTutorial
                        width: parent.width * 0.2
                        height: parent.height * 0.6
                        anchors.topMargin: 5 * ApplicationInfo.ratio
                        anchors.rightMargin: 10 * ApplicationInfo.ratio
                    }
                    AnchorChanges {
                        target: bottomRectangleTutorial
                        anchors.top: decimalNumberTutorial.bottom
                        anchors.right: topRectangleTutorial.left
                    }
                }
            ]

            Row {
                id: bottomRow
                visible: background.horizontalLayout
                width: parent.width * 0.6
                height: parent.height * 0.25
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10 * ApplicationInfo.ratio

                Repeater {
                    model: 10

                    Rectangle {
                        width: parent.width * 0.1
                        height: parent.height
                        color: index < 1 ? "#87cefa" : "transparent"
                        border.color: "black"
                        border.width: 2
                    }
                }
            }

            Column {
                id: bottomColumn
                visible: !background.horizontalLayout
                width: parent.width * 0.2
                height: parent.height * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 15 * ApplicationInfo.ratio

                Repeater {
                    model: 10

                    Rectangle {
                        width: parent.width
                        height: parent.height * 0.1
                        color: index < 1 ? "#87cefa" : "transparent"
                        border.color: "black"
                        border.width: 2
                    }
                }
            }

            Image {
                id: arrowTutorial
                source: "qrc:/gcompris/src/core/resource/bar_down.svg"

                states: [
                    State {
                        when: background.horizontalLayout
                        PropertyChanges {
                            target: arrowTutorial
                            rotation: 180
                            x: bottomRow.x
                            anchors.topMargin: 3 * ApplicationInfo.ratio
                        }
                        AnchorChanges {
                            target: arrowTutorial
                            anchors.top: bottomRow.bottom
                        }
                    },
                    State {
                        when: !background.horizontalLayout
                        PropertyChanges {
                            target: arrowTutorial
                            rotation: -90
                            y: bottomColumn.y
                            anchors.rightMargin: 3 * ApplicationInfo.ratio
                        }
                        AnchorChanges {
                            target: arrowTutorial
                            anchors.right: bottomColumn.left
                        }
                    }
                ]
                GCText {
                    id: textTutorial
                    fontSize: regularSize
                    text: Activity.toDecimalLocaleNumber(0.1)
                    font.bold: true
                    style: Text.Outline
                    styleColor: "white"
                    color: "black"
                    wrapMode: Text.WordWrap
                    fontSizeMode: Text.Fit
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                    rotation: background.horizontalLayout ? 180 : 90
                }
            }
        }

        Rectangle {
            id: answerBackground
            visible: tutorialBase.isResultTyping
            width: parent.width * 0.5
            height: parent.height * 0.15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: topRectangleTutorial.bottom
            anchors.topMargin: 5 * ApplicationInfo.ratio
            color: "#f2f2f2"
            border.color: "black"
            border.width: 2
            radius: 10

            GCText {
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#373737"
                fontSize: smallSize
                text: qsTr("Enter the result: ")
            }
        }

        Image {
            id: okButtonTutorial
            source: "qrc:/gcompris/src/core/resource/bar_ok.svg"
            visible: tutorialBase.isRepresentationShown
            anchors {
                top: tutorialBase.isSubtractionMode ? topRectangleTutorial.bottom : bottomRectangleTutorial.bottom
                bottom: parent.bottom
                right: parent.right
                left: tutorialBase.isSubtractionMode || !background.horizontalLayout? topRectangleTutorial.right : bottomRectangleTutorial.right
                leftMargin: 10 * ApplicationInfo.ratio
                rightMargin: 10 * ApplicationInfo.ratio
            }
        }
    }
}
