/* GCompris - LabelButton.qml
 *
 * SPDX-FileCopyrightText: 2024 Timothée Giet <animtim@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import core 1.0

Item {
    id: labelButton
    opacity: enabled ? 1 : 0.5
    width: buttonRow.childrenRect.width
    property int maxWidth: parent.width
    height: 10 // To be set in instance

    property alias iconSource: buttonIcon.source
    property alias text: buttonLabel.text
    property alias textColor: buttonLabel.color
    property alias fontSize: buttonLabel.fontSize
    property alias buttonIcon: buttonIcon // needed to adapt icon horizontal anchors

    signal clicked

    Row {
        id: buttonRow
        spacing: GCStyle.halfMargins
        height: parent.height

        Image {
            id: buttonIcon
            width: parent.height
            height: parent.height
            sourceSize.width: width
            sourceSize.height: height
            scale: buttonArea.pressed ? 0.9 : 1
        }

        GCText {
            id: buttonLabel
            color: GCStyle.contentColor
            fontSize: regularSize
            fontSizeMode: Text.Fit
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            height: parent.height
            width: Math.min(labelButton.maxWidth - buttonIcon.width - buttonRow.spacing, implicitWidth)
        }
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        onClicked: labelButton.clicked();
    }
}
