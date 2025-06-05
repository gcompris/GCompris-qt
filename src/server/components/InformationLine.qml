/* GCompris - InformationLine.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../singletons"

Row {
    id: informationLine
    property string label: ""
    property string info: ""
    property string textColor: Style.selectedPalette.text
    property alias infoText: infoText
    property int labelWidth: 0
    property int infoWidth: 0
    spacing: Style.margins

    DefaultLabel {
        width: informationLine.labelWidth > 0 ? informationLine.labelWidth : undefined
        horizontalAlignment: Text.AlignLeft
        text: informationLine.label
        font.bold: true
        color: enabled ? Style.selectedPalette.text : "gray"
    }

    DefaultLabel {
        id: infoText
        width: informationLine.infoWidth > 0 ? informationLine.infoWidth : undefined
        horizontalAlignment: Text.AlignLeft
        color: enabled ? informationLine.textColor : "gray"
        text: informationLine.info
    }
}
