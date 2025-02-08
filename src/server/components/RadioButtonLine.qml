/* GCompris - RadioButtonLine.qml
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
import QtQuick.Controls.Basic

import "../singletons"

Row {
    id: radioButtonLine
    property string label: ""
    property var radios: []
    property int current: 0
    Layout.preferredHeight: title.height

    signal radioCheckChanged(int index)

    Text {
        id: title
        height: contentHeight + 5
        width: labelWidth
        verticalAlignment: Text.AlignBottom
        text: radioButtonLine.label
        font.bold: true
        font.pixelSize: Style.defaultPixelSize
        color: enabled ? "black" : "gray"
    }

    ButtonGroup {
        id: childGroup
        exclusive: true
    }

    Repeater {
        model: radioButtonLine.radios
        RadioButton {
            height: parent.height
            ButtonGroup.group: childGroup
            text: modelData
            checked: index === radioButtonLine.current
            indicator.scale: Style.checkerScale
            font.pixelSize: Style.defaultPixelSize
            onClicked: radioButtonLine.radioCheckChanged(radioButtonLine.current = index)
        }
    }
}
