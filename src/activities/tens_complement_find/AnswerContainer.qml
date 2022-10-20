/* GCompris - AnswerContainer.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"

Item {
    id: answerContainer
    readonly property string correctAnswerImage: "qrc:/gcompris/src/core/resource/apply.svg"
    readonly property string wrongAnswerImage: "qrc:/gcompris/src/core/resource/cancel.svg"

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

        AnswerNumberCard {
            id: firstPlaceHolder
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            text: leftValue
            index: 0
            clickable: firstCardClickable
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

        AnswerNumberCard {
            id: secondPlaceHolder
            anchors.horizontalCenter: parent.horizontalCenter
            text: rightValue
            clickable: secondCardClickable
            index: 1
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

       AnswerNumberCard {
            id: targetNumber
            anchors.right: parent.right
            text: "10"
            clickable: false
            index: 2
        }
    }

    Image {
        id: validationImage
        visible: tickVisibility
        sourceSize.width: firstPlaceHolder.width * 0.7
        source: isCorrect ? correctAnswerImage : wrongAnswerImage
        anchors {
            left: answerRectangle.right
            leftMargin: 5
            verticalCenter: answerRectangle.verticalCenter
        }
    }
}
