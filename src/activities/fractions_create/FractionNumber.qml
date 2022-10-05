/* GCompris - FractionNumber.qml
 *
 * SPDX-FileCopyrightText: 2022 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../../core"

Item {
    id: fractionNumber
    property int value: 0
    signal leftClicked
    signal rightClicked

    property bool interactive: true
    Row {
        id: fractionRow
        Image {
            id: shiftKeyboardLeft
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            sourceSize.width: 50
            width: sourceSize.width
            height: width
            enabled: fractionNumber.interactive && !items.bonus.isPlaying
            opacity: fractionNumber.interactive ? 1 : 0
            fillMode: Image.PreserveAspectFit
            MouseArea {
                enabled: true
                anchors.fill: parent
                onClicked: {
                    leftClicked();
                }
            }
        }
        Item {
            height: fractionNumber.height
            width: shiftKeyboardLeft.width
            GCText {
                id: valueText
                text: "" + value
                font.weight: Font.DemiBold
                anchors.centerIn: parent
                color: "white"
            }
        }
        Image {
            id: shiftKeyboardRight
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.width: 50
            width: sourceSize.width
            height: width
            enabled: fractionNumber.interactive && !items.bonus.isPlaying
            opacity: fractionNumber.interactive ? 1 : 0
            fillMode: Image.PreserveAspectFit
            MouseArea {
                enabled: true
                anchors.fill: parent
                onClicked: {
                    rightClicked();
                }
            }
        }
    }
}
