/* GCompris - InformationMultiLine.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../singletons"

Row {
    id: informationLine
    property alias label: labelText.text
    property alias info: infoText.text
    property alias labelText: labelText
    property alias infoText: infoText
    height: childrenRect.height + Style.bigMargins
    spacing: Style.margins
    clip: true

    DefaultLabel {
        id: labelText
        y: Style.margins
        height: implicitHeight
        font.pixelSize: Style.textSize
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        text: informationLine.label
        font.bold: true
    }

    DefaultLabel {
        id: infoText
        y: Style.margins
        width: parent.width - labelText.width - informationLine.spacing
        height: implicitHeight
        font.pixelSize: Style.textSize
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        elide: Text.ElideNone
        wrapMode: Text.WordWrap
        text: informationLine.info
    }
}
