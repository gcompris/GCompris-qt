/* GCompris - WarningDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import "../../core"
import QtQuick.Controls 2.12
import "../server.js" as Activity

Popup {
    id: warningDialog

    property string label: "To be modified in calling element."
    property string additionalInformations: "Additional informations."
    property bool textInputReadOnly: false

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 200
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    Text {
        id: labelText

        x: parent.width / 10
        y: parent.height / 8
        text: label
        font.bold: true
        font {
            family: Style.fontAwesome
            pixelSize: 20
        }
    }

    Text {
        id: additionalInformationsText

        x: parent.width / 10
        y: parent.height / 3
        text: additionalInformations
        font.bold: true
        font {
            family: Style.fontAwesome
            pixelSize: 20
        }
    }


    ViewButton {
        id: okButton

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: qsTr("Ok")
        onClicked: {
            console.log("---- " + addModifyGroupNameTextInput.text)
            warningDialog.close()
        }

    }
}
