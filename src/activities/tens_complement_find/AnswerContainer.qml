/* GCompris - AnswerContainer.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
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
        radius: GCStyle.halfMargins
        anchors {
            fill: parent
            margins: GCStyle.halfMargins
            rightMargin: GCStyle.halfMargins + validationImage.height

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
            leftMargin: GCStyle.halfMargins
            verticalCenter: answerRectangle.verticalCenter
        }
    }
}
