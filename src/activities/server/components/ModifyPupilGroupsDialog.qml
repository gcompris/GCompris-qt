import QtQuick 2.6
import "../../../core"
import QtQuick.Controls 2.12
import "../server.js" as Activity

Popup {
    id: modifyPupilGroupsDialog

    property string label: "To be modified in calling element."
    property string inputText: "Group Name to be modified in calling element."
    property bool textInputReadOnly: false

    signal accepted(string textInputValue)

    anchors.centerIn: Overlay.overlay
    width: 400
    height: 600
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    Column {
        height: parent.height - saveButton.height

        width: parent.width

        Rectangle {
            id: deletePupilTextRectangle
            //anchors.top: parent.top
            anchors.left: parent.left

            width: parent.width
            height: 50

            Text {
                id: deletePupilGroupsText
                anchors.centerIn: parent
                text: qsTr("Delete pupil")
                font.bold: true
                color: "grey"
                font {
                  family: Style.fontAwesome
                  pixelSize: 15
                }
            }
        }

        Rectangle {
            id: deletePupilRectangle
            anchors.left: parent.left
            width: parent.width
            height: 40

            Rectangle {
                id: trashIconRectangle
                anchors.centerIn: parent
                width: 50
                height: deletePupilRectangle.height
                Text {
                    id: trashIcon
                    text: "\uf2ed"
                    anchors.centerIn: parent
                    color: "grey"
                    font {
                        family: Style.fontAwesome
                        pixelSize: Style.pixelSizeNavigationBarIcon / 2
                    }
                }
                MouseArea {
                   anchors.fill: parent
                   hoverEnabled: true
                   onClicked: {
                       //addAGroupText.color = Style.colourNavigationBarBackground
                       //removeGroupDialog.groupNameIndex = index
                   //    removeGroupDialog.open()
                       console.log("remove pupil...")
                   }
                   onEntered: { trashIcon.color = Style.colourNavigationBarBackground
                   }
                   onExited: { trashIcon.color = Style.colourCommandBarFontDisabled }
                }
            }
        }

        Rectangle {
            id: separatorLine
            anchors.left: parent.left

            width: parent.width
            height: 1
            color: "#1E000000"   //?
        }


        Rectangle {
            id: modifyGroupsTextRectangle
            anchors.left: parent.left

            width: parent.width
            height: 50

            Text {
                id: modifyGroupsText
                anchors.centerIn: parent
                text: qsTr("Modify pupil groups")
                font.bold: true
                color: "grey"
                font {
                  family: Style.fontAwesome
                  pixelSize: 15
                }
            }
        }

        ListView {
            anchors.left: parent.left
            width: parent.width
            height: 300

            model: ["Option 1", "Option 2", "Option 3","Option 1", "Option 2", "Option 3","Option 1", "Option 2", "Option 3","Option 1", "Option 2", "Option 3"]
            delegate: CheckDelegate {
                text: modelData
            }
        }
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
