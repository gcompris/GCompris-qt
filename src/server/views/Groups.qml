/* GCompris - Groups.qml
 *
 * Copyright (C) 2016 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.1
import GCompris 1.0
import QtQuick.Controls 1.0

import "../../core"

ActivityBase {
    id: activity

    activityInfo: QtObject {
        property bool demo: false
    }

    pageComponent: Item {
        anchors.fill: parent
        GridView {
            id: clients
            width: activity.width
            height: activity.height
            cellWidth: 210
            cellHeight: cellWidth
            model: MessageHandler.groups
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            delegate: Rectangle {
                id: itemDelegate
                width: 200
                height: 200
                color: "red"
                property string name: modelData.name
                GCText {
                    text: modelData.name
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    onClicked: { clients.currentIndex = index ; print(modelData.name) } // todo what do we do? display list of action? (update user list, send configuration?)
                }
            }
        }

        Grid {
            rows: 1
            anchors.bottom: bar.top
            Button {
                id: createGroupButton
                text: qsTr("Create a Group")
                style: GCButtonStyle {}
                onClicked: {
                    createGroupName.mode = "create";
                    createGroupName.visible = true;
                    createGroupName.defaultText = "";
                    createGroupName.start();
                }
            }

            Button {
                id: updateGroupButton
                text: qsTr("Update a Group")
                style: GCButtonStyle {}
                onClicked: {
                    if(clients.currentItem) {
                        createGroupName.mode = "update";
                        createGroupName.visible = true;
                        createGroupName.defaultText = clients.currentItem.name;
                        createGroupName.start();
                    }
                }
                enabled: clients.currentItem && clients.currentIndex != -1
            }

            Button {
                id: deleteGroupButton
                text: qsTr("Delete selected group")
                style: GCButtonStyle {}
                onClicked: {
                    if(clients.currentItem) {
                        MessageHandler.deleteGroup(clients.currentItem.name);
                    }
                }
                enabled: clients.currentItem && clients.currentIndex != -1
            }

            Button {
                id: sendConfiguration
                text: qsTr("Send user list")
                style: GCButtonStyle {}
                onClicked: {
                    print("select config and send config to: " + clients.currentItem.name);
                    Server.sendLoginList(MessageHandler.groups[clients.currentIndex]);
                }
                enabled: clients.currentIndex != -1
            }
        }
        GCInputDialog {
            id: createGroupName
            visible: false
            active: visible
            anchors.fill: parent
            z: 100
            property string mode: "create"
            message: mode == "create" ? qsTr("Name of the new group") : qsTr("Update group %1").arg(clients.currentItem.name)
            onClose: createGroupName.visible = false;
            button1Text: qsTr("OK")
            button2Text: qsTr("Cancel")
            onButton1Hit: {
                if(MessageHandler.users.length !== 0) {
                    chooseLogin.visible = true;
                    chooseLogin.groupname = createGroupName.inputtedText
                    chooseLogin.start();
                }
                else {
                    // no users, create the group directly
                    if(mode == "create") {
                        MessageHandler.createGroup(createGroupName.inputtedText)
                    }
                    else {
                        MessageHandler.updateGroup(clients.currentItem.name, createGroupName.inputtedText)
                    }
                }
            }

            focus: true
            onStart: {
                inputItem.text = defaultText;
                inputItem.forceActiveFocus();
            }
            onStop: activity.forceActiveFocus()

            /**
             * type:string
             * inputted default text in the TextInput.
             */
            property string defaultText

            /**
             * type:string
             * inputted text in the TextInput.
             */
            property string inputtedText: inputItem ? inputItem.text : ""

            content: TextInput {
                id: inputItem
                height: 60 * ApplicationInfo.ratio
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                text: createGroupName.defaultText
                font.pointSize: 14
                font.weight: Font.DemiBold
            }
        }

        GCInputDialog {
            id: chooseLogin
            visible: false
            active: visible
            anchors.fill: parent

            message: qsTr("Add users to group")
            onClose: chooseLogin.visible = false;

            property string groupname

            button1Text: qsTr("OK")
            onButton1Hit: {
                createGroupName.mode == "create" ?
                    MessageHandler.createGroup(groupname, selectedUsers) :
                    MessageHandler.updateGroup(clients.currentItem.name, groupname, selectedUsers)
                chooseLogin.selectedUsers = [];
            }

            focus: true

            property string chosenLogin
            property var model: MessageHandler.users

            property var selectedUsers: []
            content: ListView {
                id: view
                width: chooseLogin.width
                height: 100 * ApplicationInfo.ratio
                contentHeight: 60 * ApplicationInfo.ratio * model.count
                interactive: true
                clip: true
                model: chooseLogin.model
                delegate: GCDialogCheckBox {
                    id: userBox
                    text: modelData.name
                    // if you create a user, it's not in any group
                    // (need to handle case of existing name)
                    checked: createGroupName.mode == "create" ? false :
                                       clients.model[clients.currentIndex].hasUser(modelData.name)
                    onCheckedChanged: {
                        if(checked) {
                            chooseLogin.selectedUsers.push(modelData.name)
                        }
                        else {
                            chooseLogin.selectedUsers.splice(chooseLogin.selectedUsers.indexOf(modelData.name), 1)
                        }
                    }
                }
            }
        }

        Bar {
            id: bar
            content: BarEnumContent { value: home }
            onHomeClicked: activity.home()
        }
    }
}
