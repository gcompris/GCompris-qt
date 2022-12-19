/* GCompris - NumberQuestionCard.qml
 *
 * SPDX-FileCopyrightText: 2022 Samarth Raj <mailforsamarth@gmail.com>
 * SPDX-FileCopyrightText: 2022 Timothée Giet <animtim@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

Item {
    id: numberCard
    visible: visibility

    property bool selected: false
    property int cardSize: Math.min(width, height)

    signal clicked

    Rectangle {
        id: cardBg
        height: selected ? cardSize * 0.9 : cardSize * 0.7
        width: height
        color: isSignSymbol || !clickable ? "transparent" : "white"
        border.color: isSignSymbol || !clickable ? "transparent" : "#9FB8E3"
        border.width: selected ? 9 : 3
        radius: 15
        anchors.centerIn: parent
    }
    GCText {
        id: numberText
        width: cardBg.height
        height: cardBg.height
        anchors.centerIn: parent
        color: "#373737"
        text: value
        fontSize: Math.max(1, height) // avoid value of 0 during init
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        width: numberCard.height
        height: numberCard.height
        anchors.centerIn: parent
        enabled: clickable
        onClicked: {
            numberCard.clicked();
        }
    }
}
