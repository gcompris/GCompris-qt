/* GCompris - AddUpdateGroup.qml
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
import QtQuick 2.1
import GCompris 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0

import "../../core"
import "qrc:/gcompris/src/core/core.js" as Core

Rectangle {
    id: addUpdateRectangle
    color: "white"

    signal addGroup(var newGroup)
    signal updateGroup(var group)

    property var selectedUsers: []

    property string editedGroup: ""
    function createGroup() {
        editedGroup = ""
        groupNameFlow.name = ""
        selectedUsers = []
        // todo force focus to the text field
        groupNameFlow.forceActiveFocus()
        visible = true
    }

    function editGroup(groupName) {
        print("edit", MessageHandler.getGroup(groupName)) // crash without print
        editedGroup = groupName
        groupNameFlow.name = groupName
        selectedUsers = MessageHandler.getGroup(groupName).users.map(function(elem) { return elem.name; })
        // todo force focus to the text field
        groupNameFlow.forceActiveFocus()
        visible = true
    }

    function cloneGroup(groupName) {
        print("clone", MessageHandler.getGroup(groupName))
        editedGroup = ""
        groupNameFlow.name = groupName
        selectedUsers = MessageHandler.getGroup(groupName).users.map(function(elem) { return elem.name; })
        // todo force focus to the text field
        groupNameFlow.forceActiveFocus()
        visible = true
    }

    Flow {
        id: groupNameFlow
        spacing: 5
        property alias name: nameField.text
        Text {
            id: nameText
            text: qsTr("Group name")
        }
        TextField {
            id: nameField
            placeholderText: qsTr("Group name")
        }
    }

    TableView {
        id: usersList
        width: parent.width - 50
        height: parent.height - (bar.height * 2)
        anchors.top: groupNameFlow.bottom
        model: MessageHandler.users

        rowDelegate: Rectangle {
            height: 100
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
        }
        /*TableViewColumn {
            role: "age"
            title: qsTr("Birth year")
        }*/
        TableViewColumn {
            id: selectedColumn
            role: "selected"
            title: qsTr("Selected")
            delegate: Item {
                width: selectedColumn.height
                height: 100 // same as rowDelegate
                GCDialogCheckBox {
                    id: selectedField
                    checked: (styleData && usersList.model[styleData.row]) ? addUpdateRectangle.selectedUsers.indexOf(usersList.model[styleData.row].name) !== -1 : false
                    onClicked: {
                        print(styleData.row, usersList.model[styleData.row].name, addUpdateRectangle.selectedUsers.indexOf(usersList.model[styleData.row].name))
                        print(addUpdateRectangle.selectedUsers)
                        if(checked) {
                            addUpdateRectangle.selectedUsers.push(usersList.model[styleData.row].name)
                        }
                        else {
                            var index = addUpdateRectangle.selectedUsers.indexOf(usersList.model[styleData.row].name);
                            addUpdateRectangle.selectedUsers.splice(index, 1);
                        }
                        // restore binding for future use
                        checked = Qt.binding(function() { return (styleData && usersList.model[styleData.row]) ? addUpdateRectangle.selectedUsers.indexOf(usersList.model[styleData.row].name) !== -1 : false })
                    }
                }
            }
        }
    }

    Grid {
        rows: 1
        anchors.top: usersList.bottom
        spacing: 5
        Button {
            id: createButton
            text: editedGroup === "" ? qsTr("Create") : qsTr("Edit")
            enabled: nameField.text !== ""
            style: GCButtonStyle {}
            onClicked: {
                if(editedGroup !== "") {
                    if(groupNameFlow.name != editedGroup && MessageHandler.getGroup(groupNameFlow.name) !== null) {
                        print("Group already exist"); // todo warning dialogbox
                    }
                    else {
                        updateGroup({"oldName": editedGroup, "name": groupNameFlow.name, "users": selectedUsers})
                        selectedUsers = []
                        addUpdateRectangle.visible = false
                    }
                }
                else {
                    if(MessageHandler.getGroup(groupNameFlow.name) !== null) {
                        print("Group already exist"); // todo warning dialogbox
                    }
                    else {
                        addGroup({"name": groupNameFlow.name, "users": selectedUsers})
                        selectedUsers = []
                        addUpdateRectangle.visible = false
                    }
                }
            }
        }
        Button {
            id: cancelGroupButton
            text: qsTr("Cancel")
            style: GCButtonStyle {}
            onClicked: {
                selectedUsers = []
                addUpdateRectangle.visible = false
            }
        }
    }
}
