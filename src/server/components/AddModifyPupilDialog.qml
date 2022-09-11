/* GCompris - AddModifyPupilDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.2
import CM 1.0

Popup {
    id: addModifyPupilDialog

    property string label: "To be modified in calling element."
    property string groupsNames: "Groups Names to be modified in calling element."
    property bool textInputReadOnly: false
    property int pupilsListIndex

    property UserData currentPupil: UserData {}
    signal accepted(UserData newPupil, var groupList)

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    onOpened: pupilNameTextInput.forceActiveFocus();

    ColumnLayout {
        height: parent.height
        width: parent.width
        spacing: 20

        Text {
            id: errorMessage

            Layout.preferredHeight: 40
            Layout.preferredWidth: errorMessage.implicitWidth
            Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter

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
            text: currentPupil.name

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

        Rectangle {
            id: groupNamesRectangle

            Layout.preferredWidth: parent.width - Layout.leftMargin
            Layout.preferredHeight: 80
            Layout.fillHeight: true
            Layout.leftMargin: 40
            border.color: "red"
            border.width: 3

            ListView {
                id: groupNamesListView
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height - 10

                model: masterController.ui_groups
                delegate: CheckDelegate {
                    id: groupSelect

                    text: modelData.name
                    width: groupNamesRectangle.width / 2
                    onCheckedChanged: {
                        print("checked changed: " + index)
                    }
                }
            }
        }



        Rectangle {
            id: commandButtonsRectangle
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: saveButton.height + 5

            ViewButton {
                id: saveButton

                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: qsTr("Save")
                onClicked: {
                    currentPupil.name = pupilNameTextInput.text

                    var groupList = [];
                    // itemAtIndex(i) is Qt >= 5.13, so we workaround by looping
                    // on the currentIndex to get the information
                    for(var i = 0 ; i < groupNamesListView.count ; ++ i) {
                        groupNamesListView.currentIndex = i;
                        if(groupNamesListView.currentItem.checked) {
                            groupList.push(groupNamesListView.currentItem.text);
                        }
                    }
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
