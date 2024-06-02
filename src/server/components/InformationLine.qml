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
import QtQuick.Layouts 1.12
import "../singletons"

Row {
    property string label: ""
    property string info: ""
    property string textColor: "black"
    property alias infoText: infoText
    Text {
        height: Style.defaultLineHeight
        width: labelWidth
        verticalAlignment: Text.AlignBottom
        text: label
        font.bold: true
        font.pixelSize: Style.defaultPixelSize
        color: enabled ? "black" : "gray"
    }

    Text {
        id: infoText
        height: Style.defaultLineHeight
        width: infoWidth
        verticalAlignment: Text.AlignBottom
        color: enabled ? textColor : "gray"
        text: info
        font.pixelSize: Style.defaultPixelSize
        wrapMode: Text.WrapAnywhere
    }
}
