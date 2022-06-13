/* GCompris - AnswerContainer.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"
import "tens_complement.js" as Activity

Item {
    id: answerContainer
    readonly property string correctAnswerImage: "qrc:/gcompris/src/core/resource/apply.svg"
    readonly property string wrongAnswerImage:  "qrc:/gcompris/src/core/resource/cancel.svg"
    Rectangle {
        id: answerRectangle
        color: "#95F2F8"
        border.width: 2
        border.color: "black"
        radius: 30
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: 10
        }

        Rectangle {
            id: firstPlaceHolder
            property int columnNumber: 1
            height: parent.height
            width: Math.min(firstPlaceHolder.height, parent.width/4)
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            border.width: 2
            border.color: "black"
            color: "yellow"
            radius: parent.radius

            GCText {
                id: firstTextValue
                height: parent.height
                width: parent.width
                anchors.centerIn: parent
                text: questionValueFirst
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(firstCardClickable) {
                        if(questionValueFirst != "?") {
                            Activity.reappearNumberCard(questionValueFirst)
                        }
                        questionValueFirst = Activity.getSelectedValue()
                        Activity.updateVisibility(rowIndex)
                    }
                }
            }
        }

        GCText {
            text: "+"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors {
                left: firstPlaceHolder.right
                right: secondPlaceHolder.left
                top: parent.top
                bottom: parent.bottom
            }
        }

        Rectangle {
            id: secondPlaceHolder
            property int columnNumber: 2
            height: firstPlaceHolder.height
            width: firstPlaceHolder.width
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            color: "yellow"
            border.width: 2
            border.color: "black"
            radius: parent.radius

            GCText {
                id: secondTextValue
                height: parent.height
                width: parent.width
                anchors.centerIn: parent
                text: questionValueSecond
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(secondCardClickable) {
                        if(questionValueSecond != "?") {
                            Activity.reappearNumberCard(questionValueSecond)
                        }
                        questionValueSecond = Activity.getSelectedValue()
                        Activity.updateVisibility(rowIndex)
                    }
                }
            }
        }

        GCText {
            text: "="
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors {
                left: secondPlaceHolder.right
                right: targetNumber.left
                top: parent.top
                bottom: parent.bottom
            }
        }

        Rectangle {
            id: targetNumber
            height: firstPlaceHolder.height
            width: firstPlaceHolder.width
            anchors.right: parent.right
            color: "yellow"
            border.width: 2
            border.color: "black"
            radius: parent.radius

            GCText {
                height: parent.height
                width: parent.width
                anchors.centerIn: parent
                text: "10"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Image {
        id: validationImage
        visible: tickVisibility
        height: firstPlaceHolder.height * 0.7
        width: firstPlaceHolder.width * 0.7
        source: isCorrect ? correctAnswerImage : wrongAnswerImage
        anchors {
            left: answerRectangle.right
            leftMargin: 5
            verticalCenter: answerRectangle.verticalCenter
        }
    }
}
