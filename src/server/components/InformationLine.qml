/* GCompris - InformationLine.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../singletons"

Row {
    id: informationLine
    property string label: ""
    property string info: ""
    property string textColor: Style.selectedPalette.text
    property alias infoText: infoText
    Text {
        height: Style.lineHeight
        width: labelWidth
        verticalAlignment: Text.AlignBottom
        text: informationLine.label
        font.bold: true
        font.pixelSize: Style.textSize
        color: enabled ? Style.selectedPalette.text : "gray"
    }

    Text {
        id: infoText
        height: Style.lineHeight
        width: infoWidth
        verticalAlignment: Text.AlignBottom
        color: enabled ? informationLine.textColor : "gray"
        text: informationLine.info
        font.pixelSize: Style.textSize
        wrapMode: Text.WrapAnywhere
    }
}
