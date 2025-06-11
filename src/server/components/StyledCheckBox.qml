/* GCompris - StyledCheckBox.qml
 *
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls.Basic

import "../singletons"

AbstractButton {
    id: control
    height: Style.controlSize
    implicitWidth: text === "" ? controlImage.width : label.implicitWidth + controlImage.width + Style.margins
    checkable: true
    opacity: enabled ? 1 : 0.5

    property ButtonGroup linkedGroup: null // set a ButtonGroup property to activate tristate reflecting its checkState
    readonly property bool tristate: linkedGroup != null
    property int checkState: tristate ? linkedGroup.checkState : (checked ? Qt.Checked : Qt.Unchecked)

    onClicked: {
        if(tristate) {
            if(checkState === Qt.Checked) {
                linkedGroup.checkState = Qt.Unchecked;
            } else {
                linkedGroup.checkState = Qt.Checked;
            }
        }
    }

    property alias label: label

    Row {
        id: controlRow
        height: Style.textSize
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: controlImage
            height: Style.textSize
            width: height
            color: control.down ? Style.selectedPalette.accent : "transparent"
            border.width: control.visualFocus ? 3 : 2
            border.color: control.visualFocus ? Style.selectedPalette.highlight :
            Style.selectedPalette.text

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.5
                height: width
                color: Style.selectedPalette.text
                visible: control.checkState === Qt.Checked
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.5
                height: parent.height * 0.2
                color: Style.selectedPalette.text
                visible: control.checkState === Qt.PartiallyChecked
            }
        }

        DefaultLabel {
            id: label
            leftPadding: Style.margins
            rightPadding: Style.margins
            width: control.width - controlImage.width - Style.margins
            horizontalAlignment: Text.AlignLeft
            fontSizeMode: Text.FixedSize
            font.pixelSize: Style.textSize
            text: control.text
        }
    }
}
