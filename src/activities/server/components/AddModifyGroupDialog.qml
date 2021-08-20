import QtQuick 2.6
import "../../../core"
import QtQuick.Controls 2.12
import "../server.js" as Activity

Popup {
    id: addModifyGroupDialog

    property string label: "To be modified in calling element."
    property string inputText: "Group Name to be modified in calling element."
    property bool textInputReadOnly: false

    signal accepted(string textInputValue)

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

    TextInput {
        id: addModifyGroupNameTextInput

        x: parent.width / 10
        y: parent.height / 3
        text: inputText
        cursorVisible: false
        font {
            family: Style.fontAwesome
            pixelSize: 20
        }
        selectByMouse: true
        focus: true
        readOnly: addModifyGroupDialog.textInputReadOnly

        Component.onCompleted: addModifyGroupNameTextInput.selectAll()

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
            console.log("---- " + addModifyGroupNameTextInput.text)
            addModifyGroupDialog.accepted(addModifyGroupNameTextInput.text)
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
