import QtQuick 2.6
import "../../../core"
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2
import "../server.js" as Activity

Popup {
    id: addModifyPupilDialog

    property string label: "To be modified in calling element."
    property string pupilName: "Pupil name to be modifyed in calling element."
    property string groupsNames: "Groups Names to be modifyed in calling element."
    property bool textInputReadOnly: false
    property int pupilsListIndex

    signal accepted(string textInputValue)

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent


    ColumnLayout {
        height: parent.height
        width: parent.width
        spacing: 20

        Text {
            id: groupDialogText

            Layout.preferredHeight: 40
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 20

            text: label
            font.bold: true
            font {
                family: Style.fontAwesome
                pixelSize: 20
            }
        }

        Text {
            id: pupilNameTitleText

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40

            text: qsTr("Pupil name")
            font.bold: true
            font {
                family: Style.fontAwesome
                pixelSize: 15
            }
        }

        UnderlinedTextInput {
            id: pupilNameTextInput

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40

            defaultText: addModifyPupilDialog.pupilName    //? here we have a problem, when too long text is going left
        }

        Text {
            id: groupsListTitleText

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40

            text: qsTr("Groups")
            font.bold: true
            font {
                family: Style.fontAwesome
                pixelSize: 15
            }
        }

        UnderlinedTextInput {
            id: groupsNamesTextInput

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40

            defaultText: addModifyPupilDialog.groupsNames
        }


        Rectangle {
            id: commandButtonsRectangle
            Layout.preferredWidth: parent.width
            Layout.fillHeight: true

            ViewButton {
                id: saveButton

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: qsTr("Save")
                onClicked: {
                    console.log("---- " + addModifyPupilDialog.pupilName)
                    addModifyPupilDialog.accepted(addModifyPupilDialog.pupilName)
                    console.log("1++++---- " + pupilsListIndex)
                    console.log("2++++---- " + pupilNameTextInput.text)
                    console.log("3++++---- " + Activity.pupilsNamesArray)
                    Activity.pupilsNamesArray[pupilsListIndex][0] = "yyyy" //pupilNameTextInput.text

                    console.log("---- " + Activity.pupilsNamesArray)


                    addModifyPupilDialog.close();
                }
            }

            ViewButton {
                id: cancelButton

                anchors.right: saveButton.left
                anchors.bottom: parent.bottom
                text: qsTr("Cancel")

                onClicked: {
                   console.log("cancel...")
                   addModifyPupilDialog.close();
                }
            }
        }
    }
}
