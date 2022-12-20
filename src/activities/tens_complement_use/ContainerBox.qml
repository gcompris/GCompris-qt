/* GCompris - ContainerBox.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import "tens_complement_use.js" as Activity

Item {
    id: cardContainer
    readonly property string correctAnswerImage: "qrc:/gcompris/src/core/resource/apply.svg"
    readonly property string wrongAnswerImage:  "qrc:/gcompris/src/core/resource/cancel.svg"

    // add 1 for numbers and 0.5 for sign symbols
    function numberOfItemsInModel(modelToCheck) {
        var numberOfItems = 0;
        if(modelToCheck) {
            for (var i = 0; i < modelToCheck.count; i++) {
                if (modelToCheck.get(i).isSignSymbol) {
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
        id: containerBg
        color: "#33FFFFFF"
        radius: 15
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: background.layoutMargins
        }
    }

    Rectangle {
        id: questionContainer
        height: containerBg.height * 0.5
        width: containerBg.width * 0.6
        color: "#C8D6EF"
        anchors {
            top: containerBg.top
            horizontalCenter: containerBg.horizontalCenter
        }
        radius: 15
        property int cardWidth: questionContainer.width / numberOfItemsInModel(addition)


        ListView {
            height: parent.height
            width: parent.width
            interactive: false
            anchors.centerIn: parent
            orientation: ListView.Horizontal
            model: addition
            delegate: NumberQuestionCard {
                height: questionContainer.height
                width: isSignSymbol ? questionContainer.cardWidth * 0.5 : questionContainer.cardWidth
            }
        }
    }

    Rectangle {
        id: answerContainer
        height: containerBg.height * 0.5
        width: containerBg.width
        color: "#EBEBEB"
        anchors {
            top: questionContainer.bottom
            left: containerBg.left
        }
        radius: 15
        property int cardWidth: questionContainer.width / numberOfItemsInModel(secondRow)

        ListView {
            height: parent.height
            width: parent.width
            interactive: false
            anchors.centerIn: parent
            orientation: ListView.Horizontal
            model: secondRow
            delegate: NumberQuestionCard {
                height: answerContainer.height
                width: isSignSymbol ? questionContainer.cardWidth * 0.5 : questionContainer.cardWidth
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
            left: questionContainer.right
            bottom: answerContainer.top
        }
    }
}
