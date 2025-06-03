/* GCompris - PupilDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "qrc:/gcompris/src/server/server.js" as Server
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.2

import "../singletons"
import "../components"

Popup {
    id: pupilDialog

    property string label: "To be modified in calling element."
    property bool textInputReadOnly: false
    property int userModelIndex
    property bool addMode: true     // modify mode when false
    // Database columns
    property int modelIndex: 0      // index in Master.userModel
    property int user_Id: 0
    property string user_Name: ""
    property string user_Password: ""
    property string groups_Name: ""
    property string groups_Id: ""

    anchors.centerIn: Overlay.overlay
    width: 550
    height: 500
    modal: true
    closePolicy: Popup.CloseOnEscape

    ListModel { id: tmpGroupModel }
    ListModel { id: imagesModel }
    ListModel { id: passModel }

    function openPupilDialog(index, user_name, user_id, user_password, groups_name, groups_id) {
        modelIndex = index
        user_Name = user_name
        user_Id = user_id
        user_Password = user_password
        groups_Name = groups_name
        groups_Id = groups_id
        addMode = false
        open()
    }

    function savePupil() {
        if (pupilName.text === "") {
            errorDialog.message = [ qsTr("Pupil name is empty") ]
            errorDialog.open()
            return
        }

        var groupNamesList = [];
        var groupIdsList = []
        for (var i = 0 ; i < tmpGroupModel.count ; i ++) {
            var group = tmpGroupModel.get(i)
            if (group.group_checked) {
                groupNamesList.push(group.group_name)
                groupIdsList.push(group.group_id)
            }
        }

        var pictures = []
        for (i = 0; i < passModel.count; i++) {
            pictures.push(passModel.get(i).icon_)
        }
        var pupilPassword = pictures.join("-")

        if (addMode) {
            // Add to database the user
            user_Id = Master.createUser(pupilName.text, pupilPassword, groupNamesList, groupIdsList)
            if (user_Id !== -1)
                pupilDialog.close()
        } else {
            if (Master.updateUser(userModelIndex, user_Id, pupilName.text, pupilPassword, groupIdsList, groupNamesList))
                pupilDialog.close();
        }
    }

    onClosed: Master.filterUsers(Master.filteredUserModel, true)

    onOpened: {
        var groupIds = groups_Id.split(",").map(Number)         // split and convert elements to int
        for (var i = 0 ; i < tmpGroupModel.count ; i ++) {
            var group = tmpGroupModel.get(i)
            tmpGroupModel.setProperty(i, "group_checked", groupIds.includes(group.group_id))
        }

        imagesModel.clear()
        var passImages = Server.getPasswordImages()
        for (i = 0; i < passImages.length; i++)     // Move string array to ListModel
            imagesModel.append({ "icon_": passImages[i] })

        pupilName.forceActiveFocus();
    }

    onAboutToShow: {
        pupilName.text = user_Name
        passModel.clear()
        var pictures = user_Password.split("-")
        for (var i = 0; i < pictures.length; i++) {
            if (pictures[i] !== "")
                passModel.append({ "icon_": pictures[i]})
        }
        Master.copyModel(Master.groupModel, tmpGroupModel)
    }

    background: Rectangle {
        color: Style.selectedPalette.alternateBase
        radius: 5
        border.color: "darkgray"
        border.width: 2
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

        Text {
            id: groupDialogText
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            horizontalAlignment: Text.AlignHCenter
            text: pupilDialog.label
            font {
                bold: true
                pixelSize: 20
            }
            color: Style.selectedPalette.text
        }

        Text {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            text: qsTr("Pupil name")
            font.bold: true
            font {
                pixelSize: 15
            }
            color: Style.selectedPalette.text
        }

        UnderlinedTextInput {
            id: pupilName
            Layout.fillWidth: true
            Layout.preferredHeight: Style.lineHeight
            activeFocusOnTab: true
        }

        Text {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            text: qsTr("Password")
            font.bold: true
            font {
                pixelSize: 15
            }
            color: Style.selectedPalette.text
        }

        Rectangle {
            id: passwordList
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            border.width: 1
            color: Style.selectedPalette.accent
            ListView {
                id: passwordView
                anchors.fill: parent
                anchors.margins: 5
                contentHeight: height
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter
                orientation: ListView.Horizontal

                interactive: true
                clip: true
                model: passModel
                delegate: Image {
                    source: "qrc:/gcompris/src/server/resource/" + icon_ + ".svg"
                    sourceSize.width: 30
                    sourceSize.height: 30
                    width: 30
                    height: 30

                    MouseArea {
                        anchors.fill: parent
                        onClicked: pupilDialog.passModel.remove(index, 1)
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 40

            Text {
                Layout.preferredWidth: 150
                Layout.preferredHeight: 40
                text: qsTr("Password images")
                font.bold: true
                color: Style.selectedPalette.text
            }

            ListView {
                id: passwordChoice
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                spacing: 10
                orientation: ListView.Horizontal

                interactive: true
                clip: true
                model: Server.shuffle(imagesModel)
                delegate: Image {
                    source: "qrc:/gcompris/src/server/resource/" + icon_ + ".svg"
                    sourceSize.width: 30
                    sourceSize.height: 30
                    width: 30
                    height: 30

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (passModel.count < 4)
                                passModel.append(imagesModel.get(index))
                        }
                    }
                }
            }
        }

        Text {
            id: groupsListTitleText
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            text: qsTr("Groups")
            font.bold: true
            font {
                pixelSize: 15
            }
            color: Style.selectedPalette.text
        }

        Rectangle {
            id: groupNamesRectangle
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.selectedPalette.base
            border.color: "gray"
            border.width: 1

            ListView {
                id: groupNamesListView
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.margins: 4
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                model: tmpGroupModel
                delegate: StyledCheckDelegate {
                    id: groupSelect
                    property int group_Id: group_id
                    activeFocusOnTab: true
                    text: group_name
                    width: groupNamesRectangle.width / 2
                    checked: group_checked
                    onCheckedChanged: tmpGroupModel.setProperty(index, "group_checked", checked)
                }
            }
        }

        OkCancelButtons {
            onCancelled: pupilDialog.close()
            onValidated: savePupil()
        }

        Keys.onEnterPressed: savePupil()
        Keys.onReturnPressed: savePupil()
        Keys.onEscapePressed: pupilDialog.close()
    }
}
