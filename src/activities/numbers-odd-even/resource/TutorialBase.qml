/* GCompris - TutorialBase.qml
 *
 * SPDX-FileCopyrightText: 2019 Deepak Kumar <deepakdk2431@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Deepak Kumar <deepakdk2431@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
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
            top: parent.top
            right: parent.right
            margins: GCStyle.baseMargins
        }
        height: (parent.height - 4 * GCStyle.baseMargins) * 0.2
        text: isEvenExpected ? qsTr("Choose the even number:") : qsTr("Choose the odd number:")
        fontSize: mediumSize
        color: GCStyle.darkText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        z: 2
    }

    AnswerButton {
        id: firstNumber
        textLabel: ""
        anchors {
            top: question.bottom
            topMargin: GCStyle.baseMargins
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -width
        }
        width: Math.min(parent.width * 0.3, height * 1.5)
        height: Math.min(parent.width * 0.3, (parent.height - 4 * GCStyle.baseMargins) * 0.3)
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
            top: question.bottom
            topMargin: GCStyle.baseMargins
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: width
        }
        width: firstNumber.width
        height: firstNumber.height
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
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: firstNumber.bottom
            margins: GCStyle.baseMargins
        }
        radius: GCStyle.halfMargins
        border.width: GCStyle.thinBorder
        color: GCStyle.lightBg
        border.color: GCStyle.blueBorder
        visible: false

        GCText {
            id: message
            anchors {
                fill: parent
                margins: GCStyle.baseMargins
            }
            text: ""
            fontSizeMode: Text.Fit
            fontSize: smallSize
            color: GCStyle.darkText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: parent.width
            height: parent.height
            wrapMode: Text.WordWrap
            z: 2
        }
    }
}
