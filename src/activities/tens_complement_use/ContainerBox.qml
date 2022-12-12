/* GCompris - Card.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import "tens_complement_use.js" as Activity

Rectangle {
    id: cardContainer
    readonly property string correctAnswerImage: "qrc:/gcompris/src/core/resource/apply.svg"
    readonly property string wrongAnswerImage:  "qrc:/gcompris/src/core/resource/cancel.svg"

    color: "#F0CB38"
    border.color: "black"
    border.width: 3
    radius: 15

    Rectangle {
        id: questionContainer
        height: parent.height * 0.4
        width: parent.width * 0.6
        color: "#88A2FE"
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 15
        }
        border.width: 3
        border.color: "black"
        radius: 30

        ListView {
            height: parent.height * 0.9
            width: parent.width * 0.9
            interactive: false
            anchors.centerIn: parent
            orientation: ListView.Horizontal
            model: addition
            delegate: Card {
                height: questionContainer.height * 0.8
                width: questionContainer.width / 6
            }
        }
    }

    Rectangle {
        id: answerContainer
        height: parent.height * 0.4
        width: parent.width * 0.8
        color: "#95F2F8"
        anchors {
            top: questionContainer.bottom
            left: parent.left
            leftMargin: answerContainer.width * 0.05
            topMargin: 15
        }
        border.width: 3
        border.color: "black"
        radius: 30

        ListView {
            height: parent.height * 0.9
            width: parent.width * 0.9
            interactive: false
            anchors.centerIn: parent
            orientation: ListView.Horizontal
            model: secondRow
            delegate: Card {
                height: answerContainer.height * 0.8
                width: answerContainer.width / 10
                enabled: isAnswerCard
                onClicked: {
                    if(value != "?") {
                        Activity.reappearNumberCard(value);
                        value = "?";
                        tickVisibility = false;
                    }
                    value = Activity.getEnteredCard();
                    Activity.showOkButton();
                }
            }
        }
    }
    
    Image {
        visible: tickVisibility
        sourceSize.height: answerContainer.height
        source: isGood === true ? correctAnswerImage : wrongAnswerImage
        anchors {
            right: cardContainer.right
            leftMargin: 5
            verticalCenter: cardContainer.verticalCenter
        }
    }
}
