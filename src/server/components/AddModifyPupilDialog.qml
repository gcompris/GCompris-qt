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

Popup {
    id: addModifyPupilDialog

    property string label: "To be modified in calling element."
    property string pupilName: "Pupil name to be modifyed in calling element."
    property string groupsNames: "Groups Names to be modifyed in calling element."
    property bool textInputReadOnly: false
    property int pupilsListIndex

    signal accepted()

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

                    console.log("1++++---- " + pupilsListIndex)
                    console.log("2++++---- " + pupilNameTextInput.text)
                    console.log("3++++---- " + Activity.pupilsNamesArray)
                    Activity.pupilsNamesArray[pupilsListIndex][0] = pupilNameTextInput.text

                    //Activity.pupilsNamesArray[pupilsListIndex][0] = pupilNameTextInput.text

                    console.log("???? " + Activity.pupilsNamesArray[pupilsListIndex][2])



                    var testGroupNames = groupsNamesTextInput.text.split("-");
                    //test if all the grousp added exist
                    var allGroupsAreValid = true
                    for (var i=0; i<testGroupNames.length; i++) {
                        print(testGroupNames[i])
                        if (!Activity.groupsNamesArray.includes(testGroupNames[i])) {
                            errorMessage.text = qsTr("The following group does not exists : " + testGroupNames[i])
                            errorMessage.visible = true
                            allGroupsAreValid = false
                        }
                    }

                    //test if groups are not added twice
                    for (i=0; i<testGroupNames.length; i++) {
                        print(testGroupNames[i])
                        if (Activity.groupsNamesArray.includes(testGroupNames[i])) {
                            var idx = testGroupNames.indexOf(testGroupNames[i])
                            var idx2 = testGroupNames.indexOf(testGroupNames[i], idx+1)
                            if (idx2 !== -1) {
                                errorMessage.text = qsTr("The following group has been added more than once : " + testGroupNames[i])
                                errorMessage.visible = true
                                allGroupsAreValid = false
                            }
                        }
                    }

                    if (allGroupsAreValid === true) {
                        Activity.pupilsNamesArray[pupilsListIndex][2] = groupsNamesTextInput.text
                        addModifyPupilDialog.accepted()
                        addModifyPupilDialog.close();
                    }
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
