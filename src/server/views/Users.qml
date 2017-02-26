/* GCompris - Users.qml
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
        property string userName: userText.text
        property var groups: []
        property string avatar: avatarText.text
        property string mode: ""

        GridView {
            id: users
            width: parent.width
            height: parent.height - (bar.height * 2)
            cellWidth: parent.width/10
            cellHeight: cellWidth
            property string currentUser: ""
            model: MessageHandler.users


            delegate: Rectangle {
                id: delegate
                width: users.cellWidth/1.25
                height: width
                color: "red"
                GCText {
                    text: modelData.name
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        users.currentUser = modelData.name
                        userConfig.visible = true
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
                id: createUserButton
                text: qsTr("Create a  new user")
                style: GCButtonStyle {}
                onClicked: {
                    createUserItem.visible = true
                }
            }
        }

        Item {
            id: userConfig
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
                property var options : [
                    {
                        "shortName": "addGroups",
                        "text": qsTr("add %1 to groups").arg(users.currentUser)
                    },
                    {
                        "shortName": "showGroups",
                        "text": qsTr("show groups belonging to %1").arg(users.currentUser)
                    },
                    {
                        "shortName" : "deleteGroups",
                        "text" : qsTr("remove %1 from the groups").arg(users.currentUser)
                    },
                    {
                        "shortName" : "deleteUser",
                        "text": qsTr("delete this User ")
                    },
                    {
                        "shortName" : "activityData",
                        "text": qsTr("see the data of different activities of user %1").arg(users.currentUser)
                    }

                ]
                model: options
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
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            cancelButton.visible = false
                            configView.visible = false
                            if(modelData.shortName === "addGroups" )
                            {
                                groupsView.visible = true
                                groupsView.model = MessageHandler.groups
                                addNewGroupsButton.visible = true
                                goBackButton.visible = true
                                mainItem.mode = "addGroups";

                            }
                            if(modelData.shortName === "showGroups")
                            {
                                groupsView.model = MessageHandler.returnUserGroups(users.currentUser)
                                groupsView.visible = true
                                goBackButton.visible = true

                            }

                        }
                    }

                }
            }


            ListView {
                id: groupsView
                anchors.fill: parent
                visible: false
                model: undefined
                spacing: 50
                delegate: checkBoxDelegate

            }
            Button {
                id: addNewGroupsButton
                width: parent.width/2
                visible: false
                height: parent.height/6
                style: GCButtonStyle {}
                anchors.bottom: parent.bottom
                text: qsTr("Add")
                MouseArea {
                    anchors.fill: parent
                    onClicked: {

                        addNewGroupsButton.visible = false
                        goBackButton.visible = false
                        groupsView.visible = false
                        userConfig.visible = false
                        confirmationBox.visible = true



                    }
                }
            }
            Button {
                id: goBackButton
                width: addNewGroupsButton.visible ? parent.width/2: parent.width
                visible: false
                height: parent.height/6
                style: GCButtonStyle {}
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                text: qsTr("Back")
                MouseArea {
                    anchors.fill: parent
                    onClicked:{
                        addNewGroupsButton.visible = false
                        goBackButton.visible = false
                        groupsView.visible = false
                        configView.visible = true
                        cancelButton.visible = true
                    }
                }
            }

        }


        Item {
            id: createUserItem
            visible: false
            width:parent.width/1.75
            height: parent.height/1.5
            anchors.centerIn:  parent
            Rectangle {
                id: createUserRect
                anchors.fill: parent
                color: "grey"
                opacity: 0.6
                Button {
                    id: userName
                    anchors.left: parent.left
                    height: parent.height/8
                    width: parent.width/4

                    text: qsTr("User Name")

                    style: GCButtonStyle {}
                }
                TextField {
                    id: userText
                    anchors.left: userName.right
                    anchors.leftMargin: 30
                    anchors.right: parent.right
                    height: userName.height
                    text: ""
                    placeholderText: qsTr("Enter the name of the user")
                }

                Button {
                    id: avatar
                    anchors.left: parent.left
                    anchors.top: userName.bottom
                    anchors.topMargin: 50
                    height: parent.height/8
                    width: parent.width/4
                    text: qsTr("Avatar")
                    style: GCButtonStyle {}
                }
                TextField {
                    id: avatarText
                    anchors.left: avatar.right
                    anchors.leftMargin: 30
                    anchors.top: userText.bottom
                    anchors.topMargin: 50
                    anchors.right: parent.right
                    height: avatar.height
                    text: ""
                    placeholderText: qsTr("Add avatar for the user")
                }
                Button {
                    id: addGroups
                    height: parent.height/8
                    anchors.left: parent.left
                    anchors.topMargin: 50
                    anchors.top: avatar.bottom
                    width: parent.width/4
                    text: qsTr("Add Groups")
                    style: GCButtonStyle {}
                }

                ListView {
                    id: chooseGroups
                    anchors.left: addGroups.right
                    anchors.right: parent.right
                    anchors.top: avatarText.bottom
                    anchors.topMargin: 50
                    anchors.leftMargin: 30
                    height: parent.height/4
                    model: MessageHandler.groups
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
                                    mainItem.groups.push(modelData.name)
                                }

                                else {
                                    mainItem.groups.pop(modelData.name)
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
                Button {
                    id: create
                    width: parent.width/2
                    anchors.bottom: parent.bottom
                    height: parent.height/6
                    style: GCButtonStyle {}
                    text: qsTr("Create")
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            // display the confirmation box
                            mainItem.mode = "create"
                            confirmationBox.visible = true
                            createUserItem.visible = false

                        }
                    }

                }
                Button {
                    id: cancel
                    anchors.left: create.right
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: parent.height/6
                    style: GCButtonStyle {}
                    text: qsTr("Cancel")
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            createUserItem.visible = false

                        }
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
                        return "Are you sure you want to create this user?"
                    else if(mainItem.mode === "addGroups")
                        return "Are you sure you want to add " + users.currentUser + " to the slected groups ?"
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
                            console.log(mainItem.userName," ",mainItem.avatar, " ",
                                        mainItem.groups)
                            MessageHandler.createUser(mainItem.userName, mainItem.avatar, mainItem.groups)

                        }
                        if(mainItem.mode === "addGroups")
                        {
                            console.log(users.currentUser, mainItem.groups)
                            MessageHandler.addUserToGroup(mainItem.groups, users.currentUser)
                        }

                        userText.text = ""
                        avatarText.text = ""
                        mainItem.groups = []
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
                        userText.text = ""
                        avatarText.text = ""
                        mainItem.groups = []
                        confirmationBox.visible = false

                    }
                }
            }
        }
        GCButtonCancel {
            id: cancelButton
            visible: false
            anchors.right: undefined
            anchors.top: undefined
            anchors.bottom: userConfig.top
            anchors.left: userConfig.right
            anchors.margins: 0
            onClose: {
                cancelButton.visible = false
                userConfig.visible = false
            }
        }
        Bar {

            id: bar
            content: BarEnumContent { value: home }
            onHomeClicked: activity.home()
        }

   }
}
