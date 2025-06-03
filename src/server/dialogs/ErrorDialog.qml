/* GCompris - ErrorDialog.qml
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
import "../components"
import "../singletons"

Popup {
    id: errorDialog
    property var message: []
    anchors.centerIn: Overlay.overlay
    width: 550
    height: 300
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: 5
        border.color: "black"
        border.width: 4
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

        Text {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            horizontalAlignment: Text.AlignHCenter
            color: Style.selectedPalette.text
            text: qsTr("Information")
            font {
                bold: true
                pixelSize: 20
            }
        }

        Repeater {
            model: errorDialog.message
            Text {
                Layout.fillWidth: true
                height: 40
                horizontalAlignment: Text.AlignHCenter
                color: Style.selectedPalette.text
                text: errorDialog.message[index]
            }
        }

        OkCancelButtons {
            cancelButton.visible: false
            onValidated: errorDialog.close()
        }
    }
}
