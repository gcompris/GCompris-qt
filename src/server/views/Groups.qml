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
import QtQuick.Controls.Styles 1.0

import "../../core"

ActivityBase {
    id: activity

    activityInfo: QtObject {
        property bool demo: false
    }

    pageComponent: Item {
        id: mainItem
        anchors.fill: parent
        property string groupName: groupText.text
        property var users: []
        property string groupDescription: descriptionText.text
        property string mode:""
        GridView {
            id: clients
            width: activity.width
            height: activity.height
            cellWidth: 210
            cellHeight: cellWidth
            model: MessageHandler.groups
            property string currentGroup: ""
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
                    onClicked: { clients.currentIndex = index;
                        clients.currentGroup = name
                        print(modelData.name)
                        groupConfig.visible = true
                        configView.visible = true
                        cancelButton.visible = true
                    }
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
                    createGroupItem.visible = true;
                }
            }

        }
        Item {
            id: groupConfig
            visible: false
            width: parent.width/2.5
            height: parent.height/1.75
            anchors.centerIn: parent
            Rectangle {
                id: baseRect
                anchors.fill: parent
                color: "grey"
                opacity: 0.6
            }


            ListView {
                id: configView
                anchors.fill: parent
                visible: true
                property var list : [
                    {
                        "shortName": "addUsers",
                        "text": qsTr("add new users to %1").arg(clients.currentGroup)
                    },
                    {
                        "shortName": "showUsers",
                        "text": qsTr("show users belonging to %1").arg(clients.currentGroup)
                    },
                    {
                        "shortName": "description",
                        "text": qsTr("update description about the group")
                    },
                    {
                        "shortName" : "deleteUsers",
                        "text" : qsTr("delete users from the group %1").arg(clients.currentGroup)
                    },
                    {
                        "shortName" : "deleteGroup",
                        "text": qsTr("delete this group ")
                    },
                    {
                        "shortName" : "changeName",
                        "text" : qsTr("change name of this group ")

                    }

                ]
                model:list
                spacing: 3
                delegate: Button {
                    id: actions
                    Text {
                        text: modelData.text
                        anchors.centerIn: parent
                        color: "black"
                        font.pixelSize: 22
                    }
                    width: parent.width
                    height: 70
                    style: GCButtonStyle {}
                    //                        anchors.horizontalCenter: parent.horizontalCenter
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            cancelButton.visible = false
                            configView.visible = false
                            if(modelData.shortName === "addUsers" )
                            {
                                usersView.visible = true
                                usersView.model = MessageHandler.users
                                addNewUsersButton.visible = true
                                goBackButton.visible = true

                            }
                            else if(modelData.shortName === "showUsers") {
                                usersView.model = MessageHandler.returnGroupUsers(clients.currentGroup)
                                addNewUsersButton.visible = false
                                goBackButton.visible = true
                                usersView.visible = true

                            }
                            else if(modelData.shortName === "deleteGroup") {
                                groupConfig.visible = false
                                confirmationBox.visible = true
                                mainItem.mode = "deleteGroup"

                            }

                        }
                    }


                }
            }


            ListView {
                id: usersView
                anchors.fill: parent
                visible: false
                model: undefined
                spacing: 50
                delegate: checkBoxDelegate

            }
            Button {
                id: addNewUsersButton
                width:parent.width/2
                visible: false
                height: parent.height/6
                style: GCButtonStyle {}
                anchors.bottom: parent.bottom
                text: qsTr("Add")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        mainItem.mode = "addUsers";
                        groupConfig.visible = false
                        addNewUsersButton.visible = false
                        goBackButton.visible = false
                        usersView.visible = false
                        confirmationBox.visible = true



                    }
                }
            }
            Button {
                id: goBackButton
                width:addNewUsersButton.visible ? parent.width/2: parent.width
                visible: false
                height: parent.height/6
                style: GCButtonStyle {}
                anchors.bottom: parent.bottom
                anchors.right: parent.right
//                anchors.left: addNewUsersButton.visible? addNewUsersButton.right : undefined
                text: qsTr("Back")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        addNewUsersButton.visible = false
                        goBackButton.visible = false
                        usersView.visible = false
                        configView.visible = true
                        cancelButton.visible = true
                    }
                }
            }




        }
        GCButtonCancel {
            id: cancelButton
            visible: false
            anchors.right: undefined
            anchors.top: undefined
            anchors.bottom: groupConfig.top
            anchors.left: groupConfig.right
            anchors.margins: 0
            onClose: {
                cancelButton.visible = false
                groupConfig.visible = false
            }
        }

        Item {
            id: createGroupItem
            visible: false
            width:parent.width/1.75
            height: parent.height/1.5
            anchors.centerIn:  parent
            Rectangle {
                id: createGroupRect
                anchors.fill: parent
                color: "grey"
                opacity: 0.6
                Button {
                    id: groupName
                    anchors.left: parent.left
                    height: parent.height/8
                    width: parent.width/4

                    text: qsTr("Group Name")

                    style: GCButtonStyle {}
                }
                TextField {
                    id: groupText
                    anchors.left: groupName.right
                    anchors.leftMargin: 30
                    anchors.right: parent.right
                    height: groupName.height
                    text: ""
                    placeholderText: qsTr("Enter the group Name")
                }

                Button {
                    id: description
                    anchors.left: parent.left
                    anchors.top: groupName.bottom
                    anchors.topMargin: 50
                    height: parent.height/8
                    //                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width/4
                    text: qsTr("Description")
                    style: GCButtonStyle {}
                }
                TextField {
                    id: descriptionText
                    anchors.left: description.right
                    anchors.leftMargin: 30
                    anchors.top: groupText.bottom
                    anchors.topMargin: 50
                    anchors.right: parent.right
                    height: description.height
                    text: ""
                    placeholderText: qsTr("Add description about the group")
                }
                Button {
                    id: addUsers
                    height: parent.height/8
                    anchors.left: parent.left
                    anchors.topMargin: 50

                    anchors.top: description.bottom
                    width: parent.width/4
                    text: qsTr("Add Users")
                    style: GCButtonStyle {}
                }

                ListView {
                    id: chooseUsers
                    anchors.left: addUsers.right
                    anchors.right: parent.right
                    anchors.top: descriptionText.bottom
                    anchors.topMargin: 50
                    anchors.leftMargin: 30
                    height: parent.height/4
                    model: MessageHandler.users
                    spacing: 50
                    Component {
                        id: checkBoxDelegate
                        GCDialogCheckBox {
                            id: checkbox
                            width: parent.width
                            text:modelData.name
                            onCheckedChanged: {
                                if(checkbox.checked) {
                                    console.log("checked ",modelData.name)
                                    mainItem.users.push(modelData.name)
                                }

                                else {
                                    mainItem.users.pop(modelData.name)
                                    console.log("unchecked ", modelData.name)
                                }
                            }

                            style: CheckBoxStyle {
                                spacing: 10

                                indicator: Image {
                                    sourceSize.height: 50
                                    property string suffix: control.enabled ? ".svg" : "_disabled.svg"
                                    source:
                                        control.checked ? "qrc:/gcompris/src/core/resource/apply" + suffix :
                                                          "qrc:/gcompris/src/core/resource/cancel" + suffix
                                }
                                label: GCText {
                                    fontSize: mediumSize
                                    text: control.text
                                    wrapMode: Text.WordWrap
                                    width: parent.parent.width - 50 * ApplicationInfo.ratio - 10 * 2
                                }


                            }
                        }
                    }

                    delegate: checkBoxDelegate

                }
            }



            Button {
                id: createButton
                anchors.bottom: parent.bottom
                height: parent.height/6
                width: parent.width/2
                style: GCButtonStyle {}
                text: qsTr("Create")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //show the confirmation box
                        mainItem.mode = "create"
                        createGroupItem.visible = false
                        confirmationBox.visible = true
                    }
                }
            }
            Button {
                id: cancel
                anchors.bottom: parent.bottom
                height: parent.height/6
                anchors.left: createButton.right
                width: parent.width/2
                style: GCButtonStyle {}
                text: qsTr("Cancel")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        createGroupItem.visible = false

                    }
                }

            }



        }

        Rectangle {
            id: confirmationBox
            width: parent.width/2
            height: parent.height/4.5
            anchors.centerIn: parent
            color: "grey"
            opacity: 0.6
            visible: false
            GCText {
                text: {
                    if (mainItem.mode === "create")
                        return "Are you sure you want to create this group?"
                    else if (mainItem.mode === "addUsers")
                        return "Are you sure you want to add these users to this group?"
                    else if(mainItem.mode === "deleteGroup")
                        return "Are you sure you want to delete the group " + clients.currentGroup
                    else
                        return ""
                }

                wrapMode: Text.Wrap
                font.pixelSize: 25
                anchors.centerIn: parent

            }

            Button {
                id: yes
                anchors.bottom: parent.bottom
                height: parent.height/6
                width: parent.width/2
                style: GCButtonStyle {}
                text: qsTr("YES")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {

                        if (mainItem.mode === "create")
                        {
                            console.log(mainItem.groupName," ",mainItem.groupDescription, " ",
                                        mainItem.users)
                            MessageHandler.createGroup(mainItem.groupName, mainItem.groupDescription,
                                                    mainItem.users)
                        }
                        if (mainItem.mode === "addUsers")
                        {
                            console.log("add new users to group ",clients.currentGroup, mainItem.users)
                            MessageHandler.addUserToGroup(clients.currentGroup,mainItem.users)

                        }
                        if(mainItem.mode === "deleteGroup") {
                            console.log("deleting group ",clients.currentGroup)
                            MessageHandler.deleteGroup(clients.currentGroup)
                        }

                        groupText.text = ""
                        descriptionText.text = ""
                        mainItem.users = []
                        confirmationBox.visible = false

                    }
                }
            }
            Button {
                id: no
                anchors.bottom: parent.bottom
                height: parent.height/6
                anchors.left: yes.right
                width: parent.width/2
                style: GCButtonStyle {}
                text: qsTr("NO")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // set all the values to ""
                        groupText.text = ""
                        descriptionText.text = ""
                        mainItem.users = []
                        confirmationBox.visible = false
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

