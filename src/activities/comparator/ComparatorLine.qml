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
import core 1.0

import "../../core"

Rectangle {
    id: comparatorLine
    // height and width defined when using it

    readonly property bool currentlySelected: index === items.selectedLine

    color: items.selectedLine == index ? GCStyle.whiteBg : "transparent"
    border.color: GCStyle.blueBorder
    border.width: items.selectedLine == index ? GCStyle.thickBorder : 0

    readonly property string correctAnswerImage: "qrc:/gcompris/src/core/resource/apply.svg"
    readonly property string wrongAnswerImage: "qrc:/gcompris/src/core/resource/cancel.svg"

    Rectangle {
        id: topLine
        width: parent.width
        height: GCStyle.thinnestBorder
        color: GCStyle.blueBorder
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Rectangle {
        id: bottomLine
        width: parent.width
        height: GCStyle.thinnestBorder
        color: GCStyle.blueBorder
        anchors.verticalCenter: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ComparatorText {
        id: leftHandSideCharDisplay
        height: parent.height
        anchors.right: mathSymbolDisplayText.left
        anchors.left: parent.left
        anchors.margins: GCStyle.baseMargins
        text: leftHandSide
    }

    ComparatorText {
        id: mathSymbolDisplayText
        height: parent.height
        width: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        text: symbol
    }

    ComparatorText {
        id: rightHandSideCharDisplay
        height: parent.height
        anchors.left: mathSymbolDisplayText.right
        anchors.right: parent.right
        anchors.margins: GCStyle.baseMargins
        text: rightHandSide
    }

    Image {
        visible: isValidationImageVisible
        height: parent.height * 0.95
        width: height
        sourceSize.height: height
        sourceSize.width: height
        source: isCorrectAnswer ? correctAnswerImage : wrongAnswerImage
        anchors {
            left: comparatorLine.right
            leftMargin: GCStyle.tinyMargins
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
