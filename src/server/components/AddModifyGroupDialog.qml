/* GCompris - AddModifyGroupDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import "../../core"

Popup {
    id: addModifyGroupDialog

    property string label
    property bool textInputReadOnly: false

    property alias groupName: addModifyGroupNameTextInput.text
    signal accepted(string groupName)

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 200
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    // Always force focus on the text input when displaying the popup
    onOpened: addModifyGroupNameTextInput.forceActiveFocus();

    Text {
        id: groupDialogText

        x: parent.width / 10
        y: parent.height / 8
        text: label
        font.bold: true
        font {
            family: Style.fontAwesome
            pixelSize: 20
        }
    }

    TextInput {
        id: addModifyGroupNameTextInput
        x: parent.width / 10
        y: parent.height / 3
        cursorVisible: false
        selectByMouse: true
        anchors {
            topMargin: 20
            top: groupDialogText.bottom
            left: parent.left
            right: parent.right
        }
        readOnly: textInputReadOnly
    }

    Rectangle {
        id: underlineGroupNameTextInput

        anchors.top: addModifyGroupNameTextInput.bottom
        anchors.left: addModifyGroupNameTextInput.left
        width: addModifyGroupDialog.width * 4/6
        height: 3
        color: Style.colourNavigationBarBackground
    }

    ViewButton {
        id: saveButton

        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: qsTr("Save")
        onClicked: {
            addModifyGroupDialog.accepted(groupName)
        }

    }

    ViewButton {
        id: cancelButton

        anchors.right: saveButton.left
        anchors.bottom: parent.bottom
        text: qsTr("Cancel")
        onClicked: {
           addModifyGroupDialog.close();
        }
    }
}
