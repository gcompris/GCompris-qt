/* GCompris - RadioButtonLine.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import "../singletons"

Row {
    id: radioButtonLine

    height: Style.lineHeight

    property string label: ""
    property var radios: []
    property int current: 0
    property alias title: title
    property alias radioRepeater: radioRepeater
    property alias radioComponent: radioComponent

    signal radioCheckChanged(int index)

    DefaultLabel {
        id: title
        horizontalAlignment: Text.AlignLeft
        font.bold: true
        color: enabled ? Style.selectedPalette.text : "gray"
        text: radioButtonLine.label
        width: contentWidth

        ButtonGroup {
            id: childGroup
            exclusive: true
        }
    }

    Component {
        id: radioComponent

        StyledRadioButton {
            id: radioComponent
            required property string modelData
            required property int index
            ButtonGroup.group: childGroup
            text: modelData
            checked: index === radioButtonLine.current
            onClicked: radioButtonLine.radioCheckChanged(radioButtonLine.current = index)
        }
    }

    Repeater {
        id: radioRepeater
        model: radioButtonLine.radios
        width: radioButtonLine.width - title.width
        delegate: radioComponent
    }
}
