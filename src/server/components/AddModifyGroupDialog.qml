/* GCompris - AddModifyGroupDialog.qml
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
import CM 1.0

Popup {
    id: addModifyGroupDialog

    property string label: "To be modified in calling element."
    property string inputText: "Group Name to be modified in calling element."
    property bool textInputReadOnly: false

    property Group group: masterController.ui_newGroup

    signal accepted(Group group)

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 200
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
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

    StringEditorSingleLine {
        id: addModifyGroupNameTextInput
        stringDecorator: group.ui_name
        anchors {
            top: groupDialogText.bottom
            left: parent.left
            right: parent.right
        }
        Component.onCompleted: addModifyGroupNameTextInput.forceActiveFocus()
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
            console.log("----", group.ui_name.ui_value)
            addModifyGroupDialog.accepted(group)
        }

    }

    ViewButton {
        id: cancelButton

        anchors.right: saveButton.left
        anchors.bottom: parent.bottom
        text: qsTr("Cancel")

        onClicked: {
           console.log("cancel...")
           addModifyGroupDialog.close();
        }
    }
}
