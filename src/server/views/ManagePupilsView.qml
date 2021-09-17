/* GCompris - ManagePupilsView.qml
*
* SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
*
* Authors:
*   Emmanuel Charruau <echarruau@gmail.com>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.9
import QtQuick.Layouts 1.12
import QtQml.Models 2.12

import CM 1.0
import "../components"
import "../../core"
import QtQuick.Controls 2.2
import "."
import "../server.js" as Activity

Item {
    id: managePupilsView

    signal pupilsNamesListSelected(var pupilsNamesList)

    Connections {
        target: masterController.ui_navigationController
        onGoAddPupilDialog: addPupilDialog.open()
        onGoAddPupilsFromListDialog: addPupilsFromListDialog.open()
        onGoRemovePupilsDialog: removePupilsDialog.open()
    }

    ListView {
        id: selectedPupilsListview
    }

    Rectangle {
        anchors.fill: parent
        color: Style.colourBackground
        Text {
            anchors.centerIn: parent
            text: qsTr("Manage Pupils View")
        }
    }

    TopBanner {
        id: topBanner
        text: qsTr("Groups and pupils management")
    }

    ManageGroupsBar {
        id: pupilsNavigationBar
        anchors.top: topBanner.bottom
    }

    Rectangle {
        id: managePupilsViewRectangle
        anchors.left: pupilsNavigationBar.right
        anchors.top: topBanner.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: managePupilsView.width - pupilsNavigationBar.width

        ColumnLayout {
            id: pupilsDetailsColumn

            spacing: 2
            anchors.top: parent.top
            width: parent.width

            property int pupilNameColWidth : pupilsDetailsColumn.width / 3
            property int yearOfBirthColWidth : pupilsDetailsColumn.width / 8

            //pupils header
            Rectangle {
                id: pupilsHeaderRectangle

                height: 60
                width: parent.width

                RowLayout {
                    width: managePupilsViewRectangle.width - 10
                    height: parent.height

                    Rectangle {
                        id: pupilNameHeader
                        Layout.fillHeight: true
                        Layout.minimumWidth: pupilsDetailsColumn.pupilNameColWidth
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: Style.colourNavigationBarBackground
                            text: qsTr("Pupils Names")
                            font.bold: true
                            leftPadding: 60
                            topPadding: 20
                        }
                    }
                    Rectangle {
                        id: yearOfBirthHeader
                        Layout.fillHeight: true
                        Layout.minimumWidth: pupilsDetailsColumn.yearOfBirthColWidth     //any way to find "year of birth text width" if translations ?
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Year of Birth")
                            font.bold: true
                            color: Style.colourNavigationBarBackground
                            topPadding: 20
                        }
                    }
                    Rectangle {
                        id: pupilGroupsHeader
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            leftPadding: 10
                            text: qsTr("Groups")
                            font.bold: true
                            color: Style.colourNavigationBarBackground
                            topPadding: 20
                        }
                    }
                }
            }

            //pupils data
            Repeater {
                id: pupilsDetailsRepeater

                model: masterController.ui_users

                Rectangle {
                    id: pupilDetailsRectangle

                    //property alias pupilNameCheckBox: pupilDetailsRectangle.pupilDetailsRectangleMouseArea.pupilDetailsRectangleRowLayout.pupilName.pupilNameCheckBox

                    property alias pupilNameCheckBox: pupilNameCheckBox

                    property bool editPupilRectangleVisible: false
                    property bool optionsPupilRectangleVisible: false

                    width: managePupilsViewRectangle.width
                    height: 40

                    border.color: "green"
                    border.width: 5

                    MouseArea {
                        id: pupilDetailsRectangleMouseArea
                        anchors.right: pupilDetailsRectangle.right //right: pupilCommandOptions.right
                        anchors.top: pupilDetailsRectangle.top
                        height: pupilDetailsRectangle.height
                        width: parent.width

                        hoverEnabled: true
                        onEntered: {    //modifyPupilCommandsRectangle.visible = true
                            pupilDetailsRectangle.color = Style.colourPanelBackgroundHover
                            pupilDetailsRectangle.editPupilRectangleVisible = true
                            pupilDetailsRectangle.optionsPupilRectangleVisible = true

                        }
                        onExited: {
                            ///modifyPupilCommandsRectangle.visible = false
                            pupilDetailsRectangle.color = Style.colourBackground
                            pupilDetailsRectangle.editPupilRectangleVisible = false
                            pupilDetailsRectangle.optionsPupilRectangleVisible = false
                        }

                        RowLayout {
                            id: pupilDetailsRectangleRowLayout

                            width: parent.width
                            height: 40

                            Rectangle {
                                id: pupilName
                                Layout.alignment: Qt.AlignLeft
                                Layout.fillHeight: true
                                Layout.minimumWidth: pupilsDetailsColumn.pupilNameColWidth
                                color: "transparent"
                                CheckBox {
                                    id: pupilNameCheckBox
                                    text: modelData.name
                                    anchors.verticalCenter: parent.verticalCenter
                                    leftPadding: 20
                                }
                            }
                            Rectangle {
                                id: yearOfBirth
                                Layout.fillHeight: true
                                Layout.minimumWidth: pupilsDetailsColumn.yearOfBirthColWidth   //any way to find "year of birth text width" if translations ?
                                color: "transparent"
                                Text {
                                    id: yearText
                                    text: modelData.dateOfBirth
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: "grey"
                                }
                            }
                            Rectangle {
                                id: groups
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                height: 40
                                color: "transparent"
                                Text {
                                    id: groupsText
                                    // todo get all groups from the users
                                    text: modelData.groupsList
                                    leftPadding: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "grey"
                                }
                            }
                            Rectangle {
                                id: editPupilRectangle
                                Layout.minimumWidth: 50
                                //Layout.alignment: Qt.AlignRight
                                Layout.fillHeight: true
                                height: 40

                                visible: pupilDetailsRectangle.editPupilRectangleVisible
                                color: "transparent"
                                Text {
                                    id: editIcon
                                    text: "\uf304"
                                    anchors.centerIn: parent
                                    color: "grey"
                                    font {
                                        family: Style.fontAwesome
                                        pixelSize: Style.pixelSizeNavigationBarIcon / 2
                                    }
                                }
                                MouseArea {
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    height: parent.height
                                    width: parent.width

                                    //anchors.fill: parent
                                    hoverEnabled: true
                                    onEntered: {
                                        editIcon.color = Style.colourNavigationBarBackground //Style.colourPanelBackgroundHover
                                        //pupilDetailsRectangle.editPupilRectangleVisible = true
                                        //pupilDetailsRectangle.optionsPupilRectangleVisible = true
                                    }
                                    onExited: {
                                        ///modifyPupilCommandsRectangle.visible = false
                                        editIcon.color = Style.colourCommandBarFontDisabled //Style.colourBackground
                                        //pupilDetailsRectangle.editPupilRectangleVisible = false
                                        //pupilDetailsRectangle.optionsPupilRectangleVisible = false
                                    }
                                    onClicked: {
                                        modifyPupilDialog.pupilName = modelData.name
                                        // todo: get groups of user
                                        //modifyPupilDialog.groupsNames = modelData[2]
                                        modifyPupilDialog.pupilsListIndex = index
                                        modifyPupilDialog.open()
                                    }
                                }
                            }
                            Rectangle {
                                id: optionsPupilRectangle
                                Layout.minimumWidth: 50
                                Layout.alignment: Qt.AlignRight
                                Layout.fillHeight: true
                                height: 40

                                visible: pupilDetailsRectangle.optionsPupilRectangleVisible
                                color: "transparent"
                                Text {
                                    id: optionsIcon
                                    text: "\uf142"   //elipsis-v
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "grey"
                                    font {
                                        family: Style.fontAwesome
                                        pixelSize: Style.pixelSizeNavigationBarIcon / 2    //? see with style
                                    }
                                }
                                MouseArea {
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    height: parent.height
                                    width: parent.width

                                    hoverEnabled: true
                                    onClicked: {
                                        modifyPupilGroupsDialog.open()
                                    }

                                    onEntered: {
                                        //modifyPupilCommandsRectangle.visible = true
                                        optionsIcon.color = Style.colourNavigationBarBackground //Style.colourPanelBackgroundHover
                                        //pupilDetailsRectangle.editPupilRectangleVisible = true
                                        //pupilDetailsRectangle.optionsPupilRectangleVisible = true

                                    }
                                    onExited: {
                                        ///modifyPupilCommandsRectangle.visible = false
                                        optionsIcon.color = Style.colourCommandBarFontDisabled //Style.colourBackground
                                        //pupilDetailsRectangle.editPupilRectangleVisible = false
                                        //pupilDetailsRectangle.optionsPupilRectangleVisible = false
                                    }
                                }
                            }
                        }
                    }

                    ModifyPupilGroupsDialog {
                        id: modifyPupilGroupsDialog
                    }

                    AddModifyPupilDialog {
                        id: modifyPupilDialog

                        label: qsTr("Modify the name or the groups")

                        property string currentUserName
                        property var groupsList
                        onAccepted: {
                            // todo
                            // masterController.updateUser();
                            // masterController.updateGroupsOfUser();
                        }
                    }
                }
            }
        }
    }

    CommandBar {
        commandList: masterController.ui_commandController.ui_managePupilsViewContextCommands
    }

    AddModifyPupilDialog {
        id: addPupilDialog

        label: qsTr("Add pupil name and its group(s)")

        onAccepted: {
            console.log("save new user", newPupil.name, groupList)
            // Add to database the group
            masterController.createUser(newPupil)
            masterController.setGroupsForUser(newPupil, groupList)
            addPupilDialog.close()
        }
    }

    property UserData userToAdd: UserData {}
    AddPupilsFromListDialog {
        id: addPupilsFromListDialog

        onPupilsDetailsAdded: {
            var pupilDetailsLineArray = pupilList.split("\n")
            for (var i = 0; i < pupilDetailsLineArray.length; ++i) {
                var pupilDetails = pupilDetailsLineArray[i].split(";");
                if(pupilDetails.length > 3) {
                    print("Line", pupilDetails, "too long");
                }
                // todo check if all groups for user exist.
                // If at least one does not exist, ignore the user
                // and display a warning telling user was not added because
                // some groups do not exist
                userToAdd.name = pupilDetails[0]
                // todo check if dateOfBirth is a real year?
                userToAdd.dateOfBirth = pupilDetails[1]
                // todo have a feedback if user has not been created (already exist...)
                masterController.createUser(userToAdd)
                var groups = pupilDetails[2].split("-");
                if(groups.length != 0) {
                    masterController.setGroupsForUser(userToAdd, groups)
                }
            }
        }
    }

    RemovePupilsDialog {
        id: removePupilsDialog

        onOpened: {
            var tmpPupilsNamesList = []
            for(var i = 0 ; i < pupilsDetailsRepeater.count ; i ++) {
                if (pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.checked === true) {
                    tmpPupilsNamesList.push(pupilsDetailsRepeater.itemAt(i).pupilNameCheckBox.text)
                }
            }
            console.log(tmpPupilsNamesList)
            removePupilsDialog.pupilsNamesList = tmpPupilsNamesList
            managePupilsView.pupilsNamesListSelected(tmpPupilsNamesList)
            var pupilsNamesListStr = ""
            for(i = 0 ; i < pupilsNamesList.length ; i++) {
                pupilsNamesListStr = pupilsNamesListStr + tmpPupilsNamesList[i] + "\r\n"
            }

            pupilsNamesText.text = pupilsNamesListStr

            console.log(pupilsNamesListStr)

        }

        onAccepted: {
            print(removePupilsDialog.pupilsNamesList.length, removePupilsDialog.pupilsNamesList)
            for(var i = 0 ; i < removePupilsDialog.pupilsNamesList.length ; i++) {
                masterController.deleteUser(removePupilsDialog.pupilsNamesList[i]);
            }
        }

    }
}
