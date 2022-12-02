/* GCompris - ComparatorLine.qml
*
* SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
*
* Authors:
*   Johnny Jazeix <jazeix@gmail.com>
*   Timothée Giet <animtim@gmail.com>
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import GCompris 1.0

Rectangle {
    id: comparatorLine
    height: items.sizeOfElement
    width: parent.width

    readonly property bool currentlySelected: index === items.selectedLine

    color: items.selectedLine == index ? "#FFFFFF" : "transparent"
    border.color: "#9FB8E3"
    border.width: items.selectedLine == index ? 4 * ApplicationInfo.ratio : 0

    readonly property string correctAnswerImage: "qrc:/gcompris/src/core/resource/apply.svg"
    readonly property string wrongAnswerImage: "qrc:/gcompris/src/core/resource/cancel.svg"

    Rectangle {
        id: topLine
        width: parent.width
        height: 1 * ApplicationInfo.ratio
        color: parent.border.color
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: bottomLine
        width: parent.width
        height: topLine.height
        color: parent.border.color
        anchors.verticalCenter: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ComparatorText {
        id: leftHandSideCharDisplay
        anchors.right: mathSymbolDisplayText.left
        anchors.rightMargin: items.sizeOfElement / (30 * ApplicationInfo.ratio)
        anchors.left: parent.left
        anchors.leftMargin: 8 * ApplicationInfo.ratio
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
        anchors.leftMargin: leftHandSideCharDisplay.anchors.rightMargin
        anchors.right: parent.right
        anchors.rightMargin: leftHandSideCharDisplay.anchors.leftMargin
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
