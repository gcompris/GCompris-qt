/* GCompris - ComparatorLine.qml
*
* SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Johnny Jazeix <jazeix@gmail.com>
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0

Rectangle {
    id: comparatorLine
    height: items.sizeOfElement
    width: parent.width
    radius: height / 3

    readonly property bool currentlySelected: index === items.selectedLine

    color: items.selectedLine == index ? "lightgrey" : "transparent"
    border.color: "black"

    readonly property string correctAnswerImage: "qrc:/gcompris/src/core/resource/apply.svg"
    readonly property string wrongAnswerImage: "qrc:/gcompris/src/core/resource/cancel.svg"

    ComparatorText {
        id: leftHandSideCharDisplay
        anchors.right: mathSymbolDisplayText.left
        anchors.rightMargin: items.sizeOfElement / (30 * ApplicationInfo.ratio)
        anchors.left: parent.left
        text: leftHandSide
    }

    ComparatorText {
        id: mathSymbolDisplayText
        anchors.horizontalCenter: parent.horizontalCenter
        text: symbol
    }

    ComparatorText {
        id: rightHandSideCharDisplay
        anchors.left: mathSymbolDisplayText.right
        anchors.leftMargin: items.sizeOfElement / (30 * ApplicationInfo.ratio)
        anchors.right: parent.right
        text: rightHandSide
    }

    Image {
        visible: isValidationImageVisible
        sourceSize.width: items.sizeOfElement * 0.95
        source: isCorrectAnswer ? correctAnswerImage : wrongAnswerImage
        anchors {
            left: comparatorLine.right
            leftMargin: 5
            verticalCenter: comparatorLine.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            items.selectedLine = index
        }
    }
}
