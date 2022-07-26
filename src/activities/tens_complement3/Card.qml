/* GCompris - Card.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import "tens_complement3.js" as Activity

Rectangle {
    id: numberCard
    visible: visibility
    height: cardSize * 0.9
    width: cardSize * 0.9
    color: backgroundColor
    border.color: borderColor
    border.width: 3
    radius: 15

    GCText {
        id: numberText
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: "black"
        text: value
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if(isNumberContainerCard) {
                Activity.updateAllCardsToInitialSize()
                Activity.selected = index
                Activity.updateSize()
                Activity.numArray.push(index)
            }
            if(isAnswerCard) {
                if(numberText.text != "?") {
                    Activity.reappearNumberCard(numberText.text)
                    value = "?"
                }
                else {
                    Activity.selectedAnswerCardRow = row
                    Activity.selectedAnswerCardIndex = index
                    value = Activity.getEnteredCard()
                    Activity.showOkButton()
                }
            }
        }
    }
}
