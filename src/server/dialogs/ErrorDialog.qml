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
    width: 550
    height: 500
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    // popupType: Popup.Item // TODO: uncomment when min Qt version >= 6.8

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.text
        border.width: Style.defaultBorderWidth
    }

    DefaultLabel {
        id: errorTitle
        width: parent.width
        height: Style.mediumTextSize
        text: qsTr("Information")
        font.bold: true
    }

    Item {
        id: errorMessageArea
        width: parent.width
        anchors {
            top: errorTitle.bottom
            bottom: bottomButtons.top
            margins: Style.margins
        }
        Column {
            width: childrenRect.width
            height: childrenRect.height
            anchors.centerIn: parent
            spacing: Style.margins
            Repeater {
                anchors.centerIn: parent
                model: errorDialog.message
                DefaultLabel {
                    width: errorMessageArea.width
                    text: errorDialog.message[index]
                }
            }
        }
    }

    OkCancelButtons {
        id: bottomButtons
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        cancelButton.visible: false
        onValidated: errorDialog.close()
    }
}
