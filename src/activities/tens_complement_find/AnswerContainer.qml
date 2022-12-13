/* GCompris - AnswerContainer.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import "tens_complement_find.js" as Activity

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

        ListView {
            id: additionList
            height: parent.height * 0.9
            width: parent.width * 0.9
            interactive: false
            anchors.centerIn: parent
            orientation: ListView.Horizontal
            model: addition
            delegate: NumberQuestionCard {
                height: additionList.height * 0.8
                width: additionList.width / 5
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
        id: validationImage
        visible: tickVisibility
        sourceSize.height: answerContainer.height
        source: isCorrect ? correctAnswerImage : wrongAnswerImage
        anchors {
            left: answerRectangle.right
            leftMargin: 5
            verticalCenter: answerRectangle.verticalCenter
        }
    }
}
