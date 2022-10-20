/* GCompris - CardContainer.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"

Item {
    readonly property string correctAnswerImage: "qrc:/gcompris/src/core/resource/apply.svg"
    readonly property string wrongAnswerImage:  "qrc:/gcompris/src/core/resource/cancel.svg"

    Rectangle {
        id: cardContainer
        color: "#95F2F8"
        height: parent.height * 0.95
        width: parent.width * 0.9
        border.color: "black"
        border.width: 3
        anchors.centerIn: parent
        radius: 20

        ListView {
            height: parent.height
            width: parent.width
            interactive: false
            orientation: ListView.Horizontal
            model: listmodel
            delegate: Card {
                height: cardContainer.height
                width: cardContainer.width / listmodel.count
                containerColor: cardContainer.color
            }
        }
    }

    Image {
        visible: isValidationImageVisible
        sourceSize.width: cardContainer.height * 0.65
        source: isGood === true ? correctAnswerImage : wrongAnswerImage
        anchors {
            left: cardContainer.right
            leftMargin: 5
            verticalCenter: cardContainer.verticalCenter
        }
    }
}
