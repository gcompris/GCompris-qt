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
        }
        TableViewColumn {
            role: "dateOfBirth"
            title: qsTr("Birth year")
        }
        TableViewColumn {
            id: passwordColumn
            role: "password"
            title: qsTr("Password")
            delegate: Item {
                width: passwordColumn.height
                height: 50 // same as rowDelegate
                Item {
                    id: passwordField
                    anchors.fill: parent
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

        itemDelegate: Rectangle {
            SystemPalette {
                id: myPalette;
                colorGroup: SystemPalette.Active
            }
            color: {
                var baseColor = styleData.row % 2 == 1 ? myPalette.alternateBase : myPalette.base
                return styleData.selected ? myPalette.highlight : baseColor
            }
            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                color: "black"
                text: styleData.value
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
                visible: false
                sourceComponent: visible ? input : undefined

                Component {
                    id: input
                    TextField {
                        anchors.fill: parent
                        text: ""
                        onAccepted: {
                            loader.visible = false
                        }

                        onActiveFocusChanged: {
                            if (!activeFocus) {
                                switch(styleData.column) {
                                    case 0:
                                    userToUpdateModel.get(styleData.row).name = text
                                    break;
                                    case 1:
                                    userToUpdateModel.get(styleData.row).age = text
                                }
                                loader.visible = false
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
            onClicked: {
                userToUpdateModel.append({"name": "", "dateOfBirth": "", "password": ""})
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
