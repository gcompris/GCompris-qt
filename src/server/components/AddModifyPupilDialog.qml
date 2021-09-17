/* GCompris - AddModifyPupilDialog.qml
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
import QtQuick.Layouts 1.2
import "../server.js" as Activity
import CM 1.0

Popup {
    id: addModifyPupilDialog

    property string label: "To be modified in calling element."
    property string pupilName: "Pupil name to be modified in calling element."
    property string groupsNames: "Groups Names to be modified in calling element."
    property bool textInputReadOnly: false
    property int pupilsListIndex

    property UserData currentPupil: UserData {}
    signal accepted(UserData newPupil, var groupList)

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 400
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    ColumnLayout {
        height: parent.height
        width: parent.width
        spacing: 20

        Text {
            id: errorMessage

            Layout.preferredHeight: 40
            Layout.preferredWidth: errorMessage.implicitWidth
            Layout.alignment : Qt.AlignHCenter | Qt.AlignCenter

            font {
                family: Style.fontAwesome
                pixelSize: 15

            }
            color: "red"
            visible: false
        }

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

            defaultText: addModifyPupilDialog.pupilName //? here we have a problem, when too long text is going left
        }

        Text {
            id: pupilYearOfBirthTitleText

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40

            text: qsTr("Year of birth")
            font.bold: true
            font {
                family: Style.fontAwesome
                pixelSize: 15
            }
        }

        UnderlinedTextInput {
            id: pupilYearOfBirthTextInput

            Layout.preferredHeight: 20
            Layout.preferredWidth: parent.width
            Layout.leftMargin: 40
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
                    currentPupil.name = pupilNameTextInput.text
                    currentPupil.dateOfBirth = pupilYearOfBirthTitleText.text

                    // todo have a check list with all the existing groups instead of inputting the groups manually
                    var groupList = groupsNamesTextInput.text.split("-");

                    addModifyPupilDialog.accepted(currentPupil, groupList);
                    addModifyPupilDialog.close();
                }
            }

            ViewButton {
                id: cancelButton

                anchors.right: saveButton.left
                anchors.bottom: parent.bottom
                text: qsTr("Cancel")

                onClicked: {
                   addModifyPupilDialog.close();
                }
            }
        }
    }
}
