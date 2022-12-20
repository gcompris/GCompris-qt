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

    // add 1 for numbers and 0.5 for sign symbols
    function numberOfItemsInModel(modelToCheck) {
        var numberOfItems = 0;
        if(modelToCheck) {
            for (var i = 0; i < modelToCheck.count; i++) {
                if(modelToCheck.get(i).isSignSymbol) {
                    numberOfItems += 0.5;
                } else {
                    numberOfItems += 1;
                }
            }
            return numberOfItems;
        } else {
            return 1;
        }
    }

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
        property int cardWidth: answerRectangle.width / numberOfItemsInModel(addition)


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
                width: isSignSymbol ? answerRectangle.cardWidth * 0.5 : answerRectangle.cardWidth
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
