/* GCompris - ManageGroupsBar.qml
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
import "../../core"
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.3

import "../components"

import "../server.js" as Activity

Item {
    id: pupilsNavigationBarItem
    property bool isCollapsed: true
    property int groupTextMargin: 30

    anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
    }
    width: Style.widthNavigationButton

    Rectangle {
        id: pupilsNavigationRectangle
        width: parent.width
        height: parent.height
        color: Style.colourBackground
        border.width: 1
        border.color: "lightgrey"     

        ColumnLayout {
            id: groupNames

            spacing: 2
            anchors.top: parent.top
            width: parent.width


            //groups header
            Rectangle {
                id: test
                height: 60
                width: parent.width

                RowLayout {
                    width: parent.width
                    height: parent.height

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.minimumWidth: pupilsNavigationRectangle.width/5
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: Style.colourNavigationBarBackground
                            font {
                                family: Style.fontAwesome
                                pixelSize: Style.pixelSizeNavigationBarIcon/2
                            }
                            text: "\uf0c0"
                            font.bold: true
                            leftPadding: 20
                            topPadding: 20
                        }
                    }
                    Rectangle {
                        implicitHeight: 60
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            leftPadding: 10
                            topPadding: 20
                            text: qsTr("Groups")
                            font.bold: true
                            color: Style.colourNavigationBarBackground
                        }
                    }
                }
            }

            //groups names
            Repeater {
                id: groupsNamesRepeater
                model: masterController.ui_groups

                property string selectedGroup: ""
                Rectangle {
                    id: groupNameRectangle
                    width: groupNames.width
                    Layout.preferredHeight: 40

                    RowLayout {
                        id: groupNameRow
                        width: pupilsNavigationRectangle.width - 10
                        height: 40

                        Rectangle {
                            Layout.fillHeight: true
                            Layout.minimumWidth: pupilsNavigationRectangle.width/5
                            color: "transparent"
                            Text {
                                text: "\uf054"
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                leftPadding: 20
                                color: "grey"
                                font {
                                    family: Style.fontAwesome
                                    pixelSize: Style.pixelSizeNavigationBarIcon / 2
                                }
                            }
                        }
                        Rectangle {
                            id: groupeNameTextRectangle
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.preferredWidth: groupNameText.width
                            Layout.preferredHeight: groupNameText.height
                            color: "transparent"

                            MouseArea {
                               anchors.fill: parent
                               height: parent.height
                               width: parent.width
                               hoverEnabled: true
                               onClicked: {
                                   if(groupsNamesRepeater.selectedGroup == modelData.name) {
                                       groupsNamesRepeater.selectedGroup = "";
                                   }
                                   else {
                                       // We bind in case we update the group name
                                       // when we are already filtering to be sure
                                       // selectedGroup keeps the new name
                                       groupsNamesRepeater.selectedGroup = Qt.binding(function() { return modelData.name })
                                   }
                                   console.log("filter users to only those in", groupsNamesRepeater.selectedGroup);
                                   masterController.filterUsersView(groupsNamesRepeater.selectedGroup);
                               }
                               onEntered: { groupNameText.color = Style.colourNavigationBarBackground
                                            groupNameRectangle.color = Style.colourPanelBackgroundHover
                               }
                               onExited: { groupNameText.color = "grey"
                                           groupNameRectangle.color = Style.colourBackground
                               }
                            }

                            Text {
                                id: groupNameText

                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.name
                                color: "grey"
                                leftPadding: 5
                                elide: Text.ElideRight
                                font.underline: groupsNamesRepeater.selectedGroup == modelData.name
                            }
                        }

                        Rectangle {
                            id: elipsis
                            Layout.minimumWidth: pupilsNavigationRectangle.width/5
                            Layout.fillHeight: true
                            height: 40
                            color: "transparent"
                            Text {
                                id: elipsisText
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
                                anchors.right: elipsis.right
                                anchors.top: elipsis.top
                                height: elipsis.height
                                width: elipsis.width

                                hoverEnabled: true
                                onEntered: {    elipsisText.color = Style.colourNavigationBarBackground
                                                modifyGroupCommandsRectangle.visible = true
                                                groupNameRectangle.color = Style.colourPanelBackgroundHover
                                }
                                onExited: {     elipsisText.color = "grey"
                                                modifyGroupCommandsRectangle.visible = false
                                                groupNameRectangle.color = Style.colourBackground
                                }

                                Rectangle {
                                    id: modifyGroupCommandsRectangle

                                    anchors.right: parent.right
                                    visible: false
                                    height: groupNameRow.height
                                    width: 70
                                    color: Style.colourPanelBackgroundHover

                                    Row {
                                        width: pupilsNavigationRectangle.width/3
                                        height: parent.height
                                        anchors.fill: parent

                                        Rectangle {
                                            id: editIconRectangle

                                            width: parent.width/2
                                            height: parent.height
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
                                               anchors.fill: parent
                                               hoverEnabled: true
                                               onClicked: {
                                                   modifyGroupDialog.open()
                                               }
                                               onEntered: { editIcon.color = Style.colourNavigationBarBackground }
                                               onExited: { editIcon.color = Style.colourCommandBarFontDisabled }
                                            }
                                        }
                                        Rectangle {

                                            color: "transparent"

                                            width: parent.width/2
                                            height: parent.height

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
                                                   addAGroupText.color = Style.colourNavigationBarBackground
                                                   removeGroupDialog.open()
                                               }
                                               onEntered: { trashIcon.color = Style.colourNavigationBarBackground }
                                               onExited: { trashIcon.color = Style.colourCommandBarFontDisabled }
                                            }
                                        }
                                    }
                                }


                                AddModifyGroupDialog {
                                    id: modifyGroupDialog

                                    property string initialGroupName
                                    label: qsTr("Modify Group Name")
                                    groupName: modelData.name
                                    onOpened: {
                                        initialGroupName = modelData.name
                                        groupName = initialGroupName
                                    }
                                    onAccepted: {
                                        console.log("update group from", initialGroupName, "to", groupName)
                                        // Update to database the group
                                        masterController.updateGroup(initialGroupName, groupName)
                                        modifyGroupDialog.close()
                                    }
                                }

                                AddModifyGroupDialog {
                                    id: removeGroupDialog
                                    textInputReadOnly: true
                                    label: qsTr("Are you sure you want to remove the group?")
                                    groupName: modelData.name

                                    onAccepted: {
                                        console.log("delete group", groupName)
                                        // Delete to database the group
                                        masterController.deleteGroup(groupName)
                                        removeGroupDialog.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: addAGroupLabelRectangle

            anchors.top: groupNames.bottom
            anchors.left: parent.left

            width: parent.width - 10
            height: 40

            Text {
                id: addAGroupText
                text: "\uf067" + qsTr("Add a group")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 5
                color: "grey"
                font {
                    family: Style.fontAwesome
                    pixelSize: Style.pixelSizeNavigationBarIcon / 3   //? see with style
                }         
            }

            MouseArea {
               anchors.fill: parent
               hoverEnabled: true
               onClicked: {
                   addAGroupText.color = Style.colourNavigationBarBackground
                   addGroupDialog.open()
                   console.log("clicked ...")
               }
               onEntered: { addAGroupText.color = Style.colourNavigationBarBackground }
               onExited: { addAGroupText.color = "grey" }
            }


            AddModifyGroupDialog {
                id: addGroupDialog

                label: qsTr("Add a group name")

                onAccepted: {
                    console.log("save new group", groupName)
                    // Add to database the group
                    masterController.createGroup(groupName)
                    addGroupDialog.close()
                }
            }
        }
    }
}
