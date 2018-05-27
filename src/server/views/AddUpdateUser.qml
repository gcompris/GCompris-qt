/* GCompris - AddUpdateUser.qml
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
    anchors.fill: parent
    color: "white"

    signal addUsers(ListModel model)
    ListModel {
        id: userToUpdateModel
    }

    TableView {
        id: users
        width: parent.width - 50
        height: parent.height - (bar.height * 2)

        property var _passwords: MessageHandler.passwords;
        property string name: "";
        property string dateOfBirth: ""
        property string password: "";

        function save() {
            console.log("saving user")

            if(name != "" && dateOfBirth != "") {

                console.log("name of the user: ", name, "date of birth of the user: ", dateOfBirth, "password : ", password)

                userToUpdateModel.append({
                    "name": name,
                    "dateOfBirth": dateOfBirth,
                    "password": password
                })
                name=""
                dateOfBirth=""
                password=""
                console.log("total number of users: ", userToUpdateModel.count)
            }

        }

        model: userToUpdateModel
        selectionMode: SelectionMode.MultiSelection

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
            width: users.width/4

        }
        TableViewColumn {
            role: "dateOfBirth"
            title: qsTr("Birth year")
            width: users.width/4
        }
        TableViewColumn {
            id: passwordColumn
            role: "password"
            width: users.width/4
            signal randomPass();
            property string imgSrc: '';
            title: qsTr("Password")

            delegate: Item {
                id: passwordColumn2
                width: passwordColumn.width // same as rowDelegate
                Item {
                    id: passwordField
                    anchors.fill: parent
                    Component.onCompleted: {
                        users.password =  passwordImage.source.toString()
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            passwordImage.visible = !passwordImage.visible
                        }
                    }
                    GCText {
                        id: passwordText
                        visible: !passwordImage.visible
                        anchors.centerIn: parent
                        fontSizeMode: Text.Fit
                        text: "auto-generated"
                        font.pointSize: regularSize
                        color: "white"
                    }
                    Image {
                        id: passwordImage
                        anchors.centerIn: parent
                        source: passwordColumn.imgSrc
                        sourceSize.height: 50
                    }
                }
            }
        }
        TableViewColumn {
                id: saveDelete
                resizable: true
                title: qsTr("Save or Delete")
                signal forceFocus()
                width: users.width/4
                delegate: Item {
                    id: itemDel
                    width: 100
                    height: 40
                    anchors.topMargin: 20
                    Rectangle {
                        id: save
                        width: 100
                        height: 40
                        color: "black"
                        anchors.rightMargin: 10
                        GCText {
                            anchors.centerIn: parent
                            fontSize: tinySize
                            color: "white"
                            text: qsTr("Save")
                        }
                        MouseArea {
                            id: saveMouseArea
                            anchors.fill: parent
                            onClicked: {
                                saveDelete.forceFocus()
                                users.save()
                            }
                        }

                    }
                    Rectangle {
                        id: deleteUser
                        width: 100
                        height: 40
                        anchors.leftMargin: 10
                        anchors.left: save.right
                        color: "black"
                        GCText {
                            anchors.centerIn: parent
                            fontSize: tinySize
                            color: "white"
                            text: qsTr("Delete")
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                userToUpdateModel.remove(styleData.row)
                                users.selection.clear();
                            }
                        }
                    }
                }

            }

        itemDelegate: Rectangle {
            id: rect
            SystemPalette {
                id: myPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row % 2 == 1 ? myPalette.alternateBase : myPalette.base
                return styleData.selected ? myPalette.highlight : baseColor
            }

            MouseArea {
                id: cellMouseArea
                anchors.fill: parent
                onClicked: {
                    // Column index are zero based
                    if(styleData.column === 0 || styleData.column === 1) {
                        loader.visible = true
                        loader.item.forceActiveFocus()
                    }
                }
            }

            Loader {
                id: loader
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                height: parent.height
                width: parent.width
                visible: true
                sourceComponent: visible ? input : undefined
                Connections {
                    target: saveDelete
                    // forcing the focus triggers 'editingFinised' signal of TextField.
                    onForceFocus: {
                        loader.item.forceActiveFocus()
                    }

                }

                Component {
                    id: input
                    TextField {
                        anchors.fill: parent
                        visible: true
                        text: ""
                        onAccepted: {
                            loader.visible = false
                        }

                        onEditingFinished: {
                            switch(styleData.column) {
                                case 0: {
                                    if(text != "")
                                        users.name = text
                                    break;
                                }
                                case 1: {
                                    if(text != "")
                                        users.dateOfBirth = text
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Column {
        id: addRemoveColumn
        anchors.left: users.right
        anchors.bottom: users.bottom
        spacing: 5
        width: 50
        Button {
            id: removeSelectedUsers
            text: qsTr("-")
            enabled: users.selection.count != 0
            width: parent.width
            style: GCButtonStyle {}
            onClicked: {
                var idToRemove = []
                users.selection.forEach(function(rowIndex) {
                    idToRemove.push(rowIndex)
                });
                for(var i = idToRemove.length-1 ; i >= 0 ; -- i) {
                    userToUpdateModel.remove(idToRemove[i]);
                }
                users.selection.clear()
            }
        }
        Button {
            id: addUsersButton
            text: qsTr("+")
            width: parent.width
            style: GCButtonStyle {}
            Connections {
                target: passwordColumn
                onRandomPass: {
                    console.log("generate random pass")
                    console.log(users._passwords[0]);
                    // use the first image for now
                    passwordColumn.imgSrc = users._passwords[0];

                    console.log(passwordColumn.imgSrc);
                }
            }
            onClicked: {
//                 add empty user at first index. The first user is always going to be empty
                passwordColumn.randomPass()
                userToUpdateModel.insert(0, {"name": "", "dateOfBirth": "", "password": ""})
            }
        }
    }

    Grid {
        rows: 1
        anchors.top: users.bottom
        spacing: 5
        Button {
            id: createButton
            text: qsTr("Create")
            style: GCButtonStyle {}
            onClicked: {
                addUsers(userToUpdateModel)
                addUpdateRectangle.visible = false
            }
        }
        Button {
            id: cancelUserButton
            text: qsTr("Cancel")
            style: GCButtonStyle {}
            onClicked: {
                addUpdateRectangle.visible = false
                userToUpdateModel.clear()
            }
        }
    }
}
