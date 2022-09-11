/* GCompris - ManagePupilsView.qml
*
* SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
*
* Authors:
*   Emmanuel Charruau <echarruau@gmail.com>
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12

import CM 1.0
import "../components"
import "../../core"
import "."

Item {
    id: managePupilsView

    signal pupilsNamesListSelected(var pupilsNamesList)

    Connections {
        target: masterController.ui_navigationController
        onGoAddPupilDialog: addPupilDialog.open()
        onGoAddPupilsFromListDialog: addPupilsFromListDialog.open()
        onGoRemovePupilsDialog: removePupilsDialog.open()
        onGoAddPupilToGroupsDialog: addPupilsToGroupsDialog.open()
        onGoRemovePupilToGroupsDialog: removePupilsToGroupsDialog.open()
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

            property int pupilNameColWidth: pupilsDetailsColumn.width / 3

            //pupils header
            Rectangle {
                id: pupilsHeaderRectangle

                height: 60
                width: parent.width

                RowLayout {
                    width: managePupilsViewRectangle.width - 10
                    height: parent.height

                    CheckBox {
                        id: selectAllCheckBox
                        leftPadding: 20
                        topPadding: 20
                        onClicked: {
                            for(var i = 0 ; i < pupilsDetailsRepeater.count ; i ++) {
                                pupilsDetailsRepeater.itemAtIndex(i).pupilNameCheckBox.checked = checked;
                            }
                        }
                    }

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
            ListView {
                id: pupilsDetailsRepeater

                model: masterController.ui_users
                width: managePupilsViewRectangle.width
                height: 400 // TODO Compute the good size and unhardcode...
                contentHeight: lineHeight * count

                readonly property int lineHeight: 40
                delegate: Rectangle {
                    id: pupilDetailsRectangle

                    property alias pupilNameCheckBox: pupilNameCheckBox

                    width: managePupilsViewRectangle.width
                    height: pupilsDetailsRepeater.lineHeight

                    MouseArea {
                        id: pupilDetailsRectangleMouseArea
                        anchors.fill: parent

                        hoverEnabled: true
                        onEntered: {
                            pupilDetailsRectangle.color = Style.colourPanelBackgroundHover

                        }
                        onExited: {
                            pupilDetailsRectangle.color = Style.colourBackground
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
                                id: groups
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                height: 40
                                color: "transparent"
                                Text {
                                    id: groupsText
                                    text: modelData.groupsList
                                    leftPadding: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: "grey"
                                }
                            }
                            Button {
                                id: editPupilRectangle
                                height: 40
                                visible: pupilDetailsRectangleMouseArea.containsMouse
                                text: "\uf304"

                                onClicked: {
                                    modifyPupilDialog.currentPupil.name = modelData.name
                                    // todo: get groups of user
                                    //modifyPupilDialog.groupsNames = modelData[1]
                                    modifyPupilDialog.pupilsListIndex = index
                                    modifyPupilDialog.open()
                                }
                            }
                        }
                    }

                    AddModifyPupilDialog {
                        id: modifyPupilDialog

                        label: qsTr("Modify the name or the groups")

                        property string currentUserName
                        property var groupsList
                        onAccepted: {
                            masterController.updateUser(modelData, currentPupil, groupList);
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
                // todo have a feedback if user has not been created (already exist...)
                masterController.createUser(userToAdd)
                var groups = pupilDetails[1].split("-");
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
                if (pupilsDetailsRepeater.itemAtIndex(i).pupilNameCheckBox.checked === true) {
                    tmpPupilsNamesList.push(pupilsDetailsRepeater.itemAtIndex(i).pupilNameCheckBox.text)
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

    AddPupilsToGroupsDialog {
        id: addPupilsToGroupsDialog

        onOpened: {
            var tmpPupilsNamesList = []
            for(var i = 0 ; i < pupilsDetailsRepeater.count ; i ++) {
                if (pupilsDetailsRepeater.itemAtIndex(i).pupilNameCheckBox.checked === true) {
                    tmpPupilsNamesList.push(pupilsDetailsRepeater.itemAtIndex(i).pupilNameCheckBox.text)
                }
            }
            console.log(tmpPupilsNamesList)
            addPupilsToGroupsDialog.pupilsNamesList = tmpPupilsNamesList
            managePupilsView.pupilsNamesListSelected(tmpPupilsNamesList)
            var pupilsNamesListStr = ""
            for(i = 0 ; i < pupilsNamesList.length ; i++) {
                pupilsNamesListStr = pupilsNamesListStr + tmpPupilsNamesList[i] + "\r\n"
            }

            pupilsNamesText.text = pupilsNamesListStr

            console.log(pupilsNamesListStr)

        }

        onAccepted: {
            print(addPupilsToGroupsDialog.pupilsNamesList.length, addPupilsToGroupsDialog.pupilsNamesList, newGroups)
            for(var i = 0 ; i < addPupilsToGroupsDialog.pupilsNamesList.length ; i++) {
                masterController.addGroupsToUser(addPupilsToGroupsDialog.pupilsNamesList[i], newGroups);
            }
        }
    }

    RemovePupilsToGroupsDialog {
        id: removePupilsToGroupsDialog

        onOpened: {
            var tmpPupilsNamesList = []
            for(var i = 0 ; i < pupilsDetailsRepeater.count ; i ++) {
                if (pupilsDetailsRepeater.itemAtIndex(i).pupilNameCheckBox.checked === true) {
                    tmpPupilsNamesList.push(pupilsDetailsRepeater.itemAtIndex(i).pupilNameCheckBox.text)
                }
            }
            console.log(tmpPupilsNamesList)
            removePupilsToGroupsDialog.pupilsNamesList = tmpPupilsNamesList
            managePupilsView.pupilsNamesListSelected(tmpPupilsNamesList)
            var pupilsNamesListStr = ""
            for(i = 0 ; i < pupilsNamesList.length ; i++) {
                pupilsNamesListStr = pupilsNamesListStr + tmpPupilsNamesList[i] + "\r\n"
            }

            pupilsNamesText.text = pupilsNamesListStr

            console.log(pupilsNamesListStr)

        }

        onAccepted: {
            print(removePupilsToGroupsDialog.pupilsNamesList.length, removePupilsToGroupsDialog.pupilsNamesList, newGroups)
            for(var i = 0 ; i < removePupilsToGroupsDialog.pupilsNamesList.length ; i++) {
                masterController.removeGroupsToUser(removePupilsToGroupsDialog.pupilsNamesList[i], newGroups);
            }
        }
    }
}
