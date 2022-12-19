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
        color: "#EBEBEB"
        radius: 15
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            leftMargin: background.layoutMargins
            topMargin: background.layoutMargins
            bottomMargin: background.layoutMargins
            rightMargin: background.layoutMargins + validationImage.height

        }

        ListView {
            id: additionList
            height: parent.height
            width: parent.width
            interactive: false
            anchors.centerIn: parent
            orientation: ListView.Horizontal
            model: addition
            delegate: NumberQuestionCard {
                height: additionList.height
                width: additionList.width / 5 // 5 instead of addition.count to avoid TypeError on level load
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
        height: answerRectangle.height
        width: height
        sourceSize.height: height
        source: isCorrect ? correctAnswerImage : wrongAnswerImage
        anchors {
            left: answerRectangle.right
            leftMargin: background.layoutMargins * 0.5
            verticalCenter: answerRectangle.verticalCenter
        }
    }
}
