/* GCompris - ErrorDialog.qml
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
import QtQuick.Controls.Basic
import "../components"
import "../singletons"

Popup {
    id: errorDialog
    property var message: []
    anchors.centerIn: Overlay.overlay
    width: 600
    height: layoutColumn.height + Style.hugeMargins
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    // popupType: Popup.Item // TODO: uncomment when min Qt version >= 6.8

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
    }

    Column {
        id: layoutColumn
        anchors.centerIn: parent
        width: parent.width - Style.hugeMargins
        height: childrenRect.height
        spacing: Style.margins

        DefaultLabel {
            id: errorTitle
            width: parent.width
            height: Style.mediumTextSize
            wrapMode: Text.WordWrap
            text: qsTr("Information")
            font.bold: true
        }

        Item {
            height: Style.margins
            width: parent.width
        }

        Repeater {
            anchors.centerIn: parent
            model: errorDialog.message
            DefaultLabel {
                height: implicitHeight
                font.pixelSize: Style.textSize
                width: layoutColumn.width
                text: errorDialog.message[index]
            }
        }

        Item {
            height: Style.margins
            width: parent.width
        }

        OkCancelButtons {
            id: bottomButtons
            anchors.horizontalCenter: parent.horizontalCenter
            cancelButton.visible: false
            onValidated: errorDialog.close()
        }
    }
}
