/* GCompris - TutorialBase.qml
 *
 * SPDX-FileCopyrightText: 2019 Deepak Kumar <deepakdk2431@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../../core"

Rectangle {
    id: tutorialRectangle
    anchors.fill: parent
    color: "#80FFFFFF"
    property alias firstNumber: firstNumber.textLabel
    property alias secondNumber: secondNumber.textLabel
    property alias message: message.text
    property bool isEvenExpected: true

    GCText {
        id: question
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: parent.height * 0.1
            centerIn: parent.Center
            top: parent.top
            topMargin: parent.height * 0.05
        }
        text: isEvenExpected ? qsTr("Choose the even number:") : qsTr("Choose the odd number:")
        fontSize: mediumSize
        color: "black"
        horizontalAlignment: Text.AlignLeft
        width: 1.8 * parent.width
        height: 1.8 * parent.height
        wrapMode: Text.WordWrap
        z: 2
    }

    AnswerButton {
        id: firstNumber
        textLabel: ""
        anchors {
            top: parent.top
            topMargin: parent.height * 0.3
            left: parent.left
            leftMargin: parent.width * 0.2
        }
        width: parent.width * 0.2
        height: parent.height * 0.4
        isCorrectAnswer: (isEvenExpected && Number(textLabel) % 2 === 0) ||
                                (!isEvenExpected && Number(textLabel) % 2 !== 0)
             onPressed: {
                if(isCorrectAnswer) {
                       message.text = qsTr("Great")
                }
                   else {
                       if(isEvenExpected) {
                           message.text = qsTr("There is an error: when divided by 2, %1 leaves a remainder of 1. Therefore this is an odd number.").arg(textLabel)
                       }
                      else {
                           message.text = qsTr("There is an error: when divided by 2, %1 leaves a remainder of 0. Therefore this is an even number.").arg(textLabel)
                       }
                   }
                   message.visible = true
                   messageRectangle.visible = true
           }
    }

    AnswerButton {
        id: secondNumber
        textLabel: ""
        anchors {
            top: parent.top
            topMargin: parent.height * 0.3
            left: parent.left
            leftMargin: parent.width * 0.65
        }
        width: parent.width * 0.2
        height: parent.height * 0.4
        isCorrectAnswer: (isEvenExpected && Number(textLabel) % 2 === 0) ||
                                (!isEvenExpected && Number(textLabel) % 2 !== 0)
               onPressed: {
                   if(isCorrectAnswer) {
                       message.text = qsTr("Great")
                   }
                   else {
                       if(isEvenExpected) {
                           message.text = qsTr("There is an error: when divided by 2, %1 leaves a remainder of 1. Therefore this is an odd number.").arg(textLabel)
                       }
                       else {
                           message.text = qsTr("There is an error: when divided by 2, %1 leaves a remainder of 0. Therefore this is an even number.").arg(textLabel)
                       }
                   }
                   message.visible = true
                   messageRectangle.visible = true
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
