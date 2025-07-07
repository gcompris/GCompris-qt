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
    property alias label: labelText.text
    property alias info: infoText.text
    // TODO: remove all use of textColor (replace with visual symbols), then remove it here.
    property color textColor: Style.selectedPalette.text
    property alias labelText: labelText
    property alias infoText: infoText
    property int labelWidth: 0
    property int infoWidth: 0
    height: Style.lineHeight
    spacing: Style.margins
    clip: true

    property bool showResult: false
    property alias resultSuccess: infoResult.resultSuccess

    property int infoResultWidth: showResult ? infoResult.width + spacing : 0

    DefaultLabel {
        id: labelText
        width: informationLine.labelWidth > 0 ? informationLine.labelWidth :
            Math.min(implicitWidth,
                (informationLine.width - informationLine.spacing - informationLine.infoResultWidth) * 0.5)
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignLeft
        text: informationLine.label
        font.bold: true
        color: enabled ? Style.selectedPalette.text : "gray"
    }

    DefaultLabel {
        id: infoText
        width: informationLine.infoWidth > 0 ? informationLine.infoWidth :
            Math.min(implicitWidth, informationLine.width - informationLine.spacing - informationLine.infoResultWidth - labelText.width)
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignLeft
        color: enabled ? informationLine.textColor : "gray"
        text: informationLine.info
    }

    ResultIndicator {
        id: infoResult
        visible: informationLine.showResult
        resultSuccess: false
    }
}
