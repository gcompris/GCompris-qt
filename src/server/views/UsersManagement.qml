/* GCompris - UsersManagement.qml
 *
 * Copyright (C) 2017 Johnny Jazeix <jazeix@gmail.com>
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
import QtQuick 2.6
import GCompris 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

ActivityBase {
    id: activity

    activityInfo: QtObject {
        property bool demo: false
    }

    pageComponent: Item {
        id: mainItem
        anchors.fill: parent
        
        ListView {
            id: groupList
            anchors.left: parent.left
            model: MessageHandler.groups
            width: parent.width / 5
            height: parent.height - (bar.height * 2)
            headerPositioning: ListView.OverlayHeader

            header: Rectangle {
                z: groupList.z + 1
                width: groupList.width
                height: 50
                radius: 10
                color: "white"
                border.color: "black"
                border.width: 3
                GCText {
                    id: contactInfo
                    text: qsTr("Groups")
                    anchors.fill: parent
                    width: parent.width
                    height: parent.height
                    fontSizeMode: Text.Fit
                    color: "black"
                }
            }

            footerPositioning: ListView.OverlayFooter
            footer: Flow {
                z: groupList.z + 1
                width: groupList.width
                height: 50
                Button { // todo put images? Add, Clone, Edit, Delete
                    text: qsTr("+")
                    onClicked: addGroupTable.createGroup()
                }
                Button {
                    text: qsTr("Edit")
                    onClicked: {
                        print(groupList.model); // crash without print
                        addGroupTable.editGroup(groupList.model[groupList.currentIndex].name)
                    }
                }
                Button {
                    text: qsTr("Clone")
                    onClicked: {
                        print(groupList.model); // crash without print
                        addGroupTable.cloneGroup(groupList.model[groupList.currentIndex].name)
                    }
                }
                Button {
                    text: qsTr("-")
                    onClicked: {
                        Core.showMessageDialog(
                        main,
                        qsTr("Delete group %1?").arg(groupList.model[groupList.currentIndex].name),
                        qsTr("Yes"),
                        function() {
                            MessageHandler.deleteGroup(groupList.model[groupList.currentIndex].name)
                        },
                        qsTr("No"), null,
                        function() { }
                        );
                    }
                }
            }
            delegate: Rectangle {
                id: wrapper
                z: groupList.z
                width: groupList.width
                height: 50
                radius: 10
                color: wrapper.ListView.isCurrentItem ? "black" : "white"
                GCText {
                    id: contactInfo
                    text: modelData.name
                    color: wrapper.ListView.isCurrentItem ? "white" : "black"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: groupList.currentIndex = index
                }
            }
        }

        AddUpdateGroup {
            id: addGroupTable
            visible: false
            anchors.fill: parent
            z: users.z + 1
            onAddGroup: {
                print(newGroup.name, newGroup.users)
                MessageHandler.createGroup(newGroup.name, "", newGroup.users)
            }
            onUpdateGroup: {
                print(group.oldName, group.name, group.users)
                MessageHandler.updateGroup(group.oldName, group.name, "", group.users)
            }
        }

        Rectangle {
            id: userText
            anchors.left: groupList.right
            width: users.width
            height: 50
            radius: 10
            color: "white"
            border.color: "black"
            border.width: 3
            GCText {
                id: contactInfo
                text: qsTr("Users")
                anchors.fill: parent
                width: parent.width
                height: parent.height
                fontSizeMode: Text.Fit
                color: "black"
            }
        }

        TableView {
            id: users
            anchors.left: groupList.right
            anchors.right: parent.right
            anchors.top: userText.bottom
            height: parent.height - (bar.height * 2) - userText.height

            model: MessageHandler.users

            rowDelegate: Rectangle {
                height: 50
                width: childrenRect.width
                SystemPalette {
                    id: myPalette;
                    colorGroup: SystemPalette.Active
                }
                color: {
                    var baseColor = styleData.alternate ? myPalette.alternateBase : myPalette.base
                    return styleData.selected ? myPalette.highlight : baseColor
                }
            }
            TableViewColumn {
                role: "name"
                title: qsTr("Name")
                width: users.width / 5
            }
            TableViewColumn {
                role: "dateOfBirth"
                title: qsTr("Birth year")
                width: parent.width / 5
            }
            TableViewColumn {
                id: passwordColumn
                role: "password"
                title: qsTr("Password")
                width: users.width / 5
                delegate: Item { // todo Put it in a separate file
                    width: passwordColumn.height
                    height: 50 // same as rowDelegate
                    Button {
                        id: passwordButton
                        text: qsTr("Show password")
                        //style: GCButtonStyle {}
                        onClicked: {
                            passwordButton.visible = false
                        }
                    }
                    Item {
                        id: passwordField
                        anchors.fill: parent
                        visible: !passwordButton.visible
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                passwordImage.visible = !passwordImage.visible
                            }
                        }
                        Text {
                            id: passwordText
                            visible: !passwordImage.visible
                            verticalAlignment: Text.AlignVCenter
                            fontSizeMode: Text.Fit
                            text: modelData ? modelData.password : ""
                        }
                        Image {
                            id: passwordImage
                            source: "qrc:/gcompris/src/activities/sudoku/sudoku.svg"
                            sourceSize.height: 50
                        }
                    }
                }
            }
            TableViewColumn {
                id: groupsColumn
                role: "groups"
                title: qsTr("Groups")
                width: 2 * users.width / 5
                delegate: Text {
                    verticalAlignment: Text.AlignVCenter
                    fontSizeMode: Text.Fit
                    text: {
                        // todo clean up...
                        MessageHandler.groups.filter(function(elem) {
                                        return elem.users.filter(function(elem) { return modelData && (elem.name == modelData.name) }).length != 0
                                    }).map(function(elem) { return elem.name; }).join(", ")
                    }
                }
            }
        }

        Grid {
            rows: 1
            anchors.bottom: bar.top
            spacing: 5
            Button {
                id: createUserButton
                text: qsTr("Add user(s)")
                style: GCButtonStyle {}
                onClicked: {
                    addUserTable.visible = true
                }
            }
            Button {
                id: updateUserButton
                enabled: users.selection.count != 0
                text: qsTr("Edit user")
                style: GCButtonStyle {}
                onClicked: {
                    users.selection.forEach(function(rowIndex) {
                        print("edit user " + users.model[rowIndex].name)
                    });
                    //addUserTable.visible = true
                }
            }
            Button {
                id: deleteUserButton
                enabled: users.selection.count != 0
                text: qsTr("Delete selected")
                style: GCButtonStyle {}
                onClicked: {
                    Core.showMessageDialog(
                        main,
                        qsTr("Confirm the deletion of selected users"),
                        qsTr("Yes"),
                        function() {
                            var namesToRemove = [];
                            users.selection.forEach(function(rowIndex) {
                                namesToRemove.push(users.model[rowIndex].name)
                            });
                            for(var name in namesToRemove) {
                                print("Removing", namesToRemove[name])
                                MessageHandler.deleteUser(namesToRemove[name])
                            }
                            users.selection.clear()
                        },
                        qsTr("No"), null,
                        function() { }
                    );
                }
            }
        }

        AddUpdateUser {
            id: addUserTable
            visible: false
            onAddUsers: {
                for(var i = model.count-1 ; i >= 0 ; -- i) {
                    var userToAdd = model.get(i)
                    MessageHandler.createUser(userToAdd.name, userToAdd.dateOfBirth, userToAdd.password)
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

