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

    signal clicked

    Rectangle {
        height: selected ? parent.height : parent.height * 0.9
        width: height
        color: isSignSymbol ? "transparent" : (clickable ? "#FFFB9A" : "orange")
        border.color: isSignSymbol ? "transparent" : "black"
        border.width: 3
        radius: 15
        anchors.centerIn: parent
    }
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
        enabled: clickable
        onClicked: {
            numberCard.clicked();
        }
    }
}
