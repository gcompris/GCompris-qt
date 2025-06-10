/* GCompris - PupilDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import "qrc:/gcompris/src/server/server.js" as Server
import QtQuick.Controls.Basic

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

    // popupType: Popup.Item // TODO: uncomment when min Qt version >= 6.8
    anchors.centerIn: Overlay.overlay
    width: Overlay.overlay.width
    height: Overlay.overlay.height
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
            errorDialog.message = [ qsTr("Pupil's name is empty") ]
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
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.text
        border.width: Style.defaultBorderWidth
    }

    Column {
        id: topColumn
        width: parent.width
        height: childrenRect.height
        spacing: Style.margins

        Keys.onEnterPressed: savePupil()
        Keys.onReturnPressed: savePupil()
        Keys.onEscapePressed: pupilDialog.close()

        DefaultLabel {
            id: groupDialogText
            width: parent.width
            height: Style.mediumTextSize
            text: pupilDialog.label
            font.bold: true
        }

        Item {
            id: spacerTitle
            height: Style.margins
            width: 1
        }

        DefaultLabel {
            width: parent.width
            text: qsTr("Pupil's name")
            font.bold: true
        }

        UnderlinedTextInput {
            id: pupilName
            width: parent.width
            activeFocusOnTab: true
        }

        DefaultLabel {
            width: parent.width
            text: qsTr("Password")
            font.bold: true
        }

        Rectangle {
            id: passwordList
            width: parent.width
            height: Style.bigControlSize
            border.width: 1
            border.color: Style.selectedPalette.accent
            color: Style.selectedPalette.alternateBase
            ListView {
                id: passwordView
                anchors.fill: parent
                anchors.margins: Style.smallMargins
                anchors.leftMargin: Style.margins
                anchors.rightMargin: Style.margins
                contentHeight: height
                spacing: Style.margins
                anchors.horizontalCenter: parent.horizontalCenter
                orientation: ListView.Horizontal
                interactive: true
                clip: true
                model: passModel
                delegate: Image {
                    source: "qrc:/gcompris/src/server/resource/" + icon_ + ".svg"
                    sourceSize.height: height
                    height: passwordView.height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: passModel.remove(index, 1)
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: Style.bigControlSize
            color: Style.selectedPalette.alternateBase

            Row {
                anchors.fill: parent
                anchors.leftMargin: Style.margins
                anchors.rightMargin: Style.margins
                spacing: Style.margins

                DefaultLabel {
                    id: passwordImagesLabel
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Password images:")
                    font.bold: true
                    color: Style.selectedPalette.text
                }

                ListView {
                    id: passwordChoice
                    width: parent.width - passwordImagesLabel.width - Style.margins
                    height: parent.height - Style.margins
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.margins
                    orientation: ListView.Horizontal
                    interactive: true
                    clip: true
                    model: Server.shuffle(imagesModel)
                    delegate: Image {
                        source: "qrc:/gcompris/src/server/resource/" + icon_ + ".svg"
                        sourceSize.height: height
                        height: passwordChoice.height

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
        }

        DefaultLabel {
            id: groupsListTitleText
            width: parent.width
            text: qsTr("Groups")
            font.bold: true
        }
    }

    Rectangle {
        id: groupNamesRectangle
        width: parent.width
        anchors.top: topColumn.bottom
        anchors.bottom: bottomButtons.top
        anchors.margins: Style.margins
        color: Style.selectedPalette.alternateBase
        border.color: Style.selectedPalette.accent
        border.width: 1

        ListView {
            id: groupNamesListView
            anchors.fill: parent
            anchors.centerIn: parent
            anchors.margins: Style.margins
            boundsBehavior: Flickable.StopAtBounds
            clip: true
            model: tmpGroupModel
            delegate: StyledCheckBox {
                id: groupSelect
                property int group_Id: group_id
                activeFocusOnTab: true
                text: group_name
                width: groupNamesRectangle.width * 0.5
                checked: group_checked
                onCheckedChanged: tmpGroupModel.setProperty(index, "group_checked", checked)
            }
        }
    }

    OkCancelButtons {
        id: bottomButtons
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onCancelled: pupilDialog.close()
        onValidated: savePupil()
    }
}
