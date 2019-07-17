/* GCompris - TutorialBase.qml
 *
 * Copyright (C) 2019 Akshay Kumar <email.akshay98@gmail.com>
 *
 * Authors:
 *   Akshay Kumar <email.akshay98@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import "../../../core"

Rectangle {
    id: tutorialRectangle
    anchors.fill: parent
    color: "#80FFFFFF"
    property alias firstNumber: firstNumber.textLabel
    property alias secondNumber: secondNumber.textLabel
    property alias questionText: question.text
    property int answer

    GCText {
        id: question
        fontSizeMode: Text.Fit
        fontSize: mediumSize
        anchors.left: tutorialRectangle.left
        anchors.leftMargin: parent.height * 0.01
        color: "black"
        horizontalAlignment: Text.AlignLeft
        width: parent.width
        height: parent.height
        wrapMode: Text.WordWrap
        z: 2
    }

    AnswerButton {
        id: firstNumber
        visible: answer
        textLabel: ""
        anchors {
            top: parent.top
            topMargin: parent.height * 0.3
            left: parent.left
            leftMargin: parent.width * 0.2
        }
        width: parent.width * 0.2
        height: parent.height * 0.4
        isCorrectAnswer: Number(textLabel) === tutorialRectangle.answer
        onPressed: {
            if(isCorrectAnswer) {
                message.text = qsTr("Great")
                message.visible = true
                messageRectangle.visible = true
            }
        }
    }

    AnswerButton {
        id: secondNumber
        textLabel: ""
        visible: answer
        anchors {
            top: parent.top
            topMargin: parent.height * 0.3
            left: parent.left
            leftMargin: parent.width * 0.65
        }
        width: parent.width * 0.2
        height: parent.height * 0.4
        isCorrectAnswer: Number(textLabel) === tutorialRectangle.answer
        onPressed: {
            if(isCorrectAnswer) {
                message.text = qsTr("Great")
                message.visible = true
                messageRectangle.visible = true
            }
        }
        
    }

    Rectangle {
        id: messageRectangle
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: parent.height * 0.75
        }
        opacity: 0.8
        radius: 10
        border.width: 6
        color: "white"
        border.color: "#87A6DD"
        width: parent.width * 1.15
        height: parent.height * 0.4
        visible: false

        GCText {
            id: message
            anchors {
                centerIn: parent
                margins: parent.border.width+1
            }
            text: ""
            fontSizeMode: Text.Fit
            fontSize: smallSize
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: parent.width
            height: parent.height
            wrapMode: Text.WordWrap
            z: 2
        }
    }
}
