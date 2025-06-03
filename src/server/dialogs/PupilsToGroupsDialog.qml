/* GCompris - PupilsToGroupsDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.15
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.12

import "../singletons"
import "../components"

Popup {
    id: pupilsToGroupsDialog

    property bool addMode: true        // add pupil or remove pupil mode

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    ListModel { id: pupilModel }
    ListModel { id: tmpGroupModel }

    onAboutToShow: {
        Master.copyModel(Master.groupModel, tmpGroupModel)
        pupilModel.clear()
        for(var i = 0 ; i < Master.filteredUserModel.count ; i ++) {
            var user = Master.filteredUserModel.get(i)
            if (user.user_checked) {
                pupilModel.append(user)
            }
        }
        for (i = 0 ; i < tmpGroupModel.count ; i ++) {
            tmpGroupModel.setProperty(i, "group_checked", false)
        }
    }

    function validateDialog() {
        var groupIds = []
        for (var i = 0 ; i < tmpGroupModel.count ; i ++) {
            var group = tmpGroupModel.get(i)
            if (group.group_checked)
                groupIds.push(group.group_id)
        }
        if (addMode) {
            for(i = 0 ; i < pupilModel.count ; i++)
                 Master.addGroupUser(pupilModel, i, groupIds)
        } else {
            for(i = 0 ; i < pupilModel.count ; i++)
                Master.removeGroupUser(pupilModel, i, groupIds)
        }
        Master.filterUsers(Master.filteredUserModel, true)
        pupilsToGroupsDialog.close()
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
            id: deletePupilGroupsText
            Layout.fillWidth: true
            Layout.preferredHeight: 90
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: pupilsToGroupsDialog.addMode ? qsTr("Do you want to add these pupils to the following groups?")
                           : qsTr("Are you sure you want to remove these pupils from the following groups?")
            font {
                bold: true
                pixelSize: 20
            }
            color: Style.selectedPalette.text
        }

        Rectangle {
            id: pupilsNamesTextRectangle
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            border.color: "gray"
            border.width: 1
            color: Style.selectedPalette.base

            GridView {
                anchors.fill: parent
                cellWidth: width / 4
                cellHeight: 20
                anchors.margins: 3
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                model: pupilModel

                delegate: Column {
                    Text {
                        text: user_name
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: Style.selectedPalette.text
                    }
                }
            }
        }

        Rectangle {
            id: groupNamesRectangle
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Style.selectedPalette.base
            border.color: "gray"
            border.width: 1

            GridView {
                id: groupNamesListView
                anchors.fill: parent
                anchors.centerIn: parent
                anchors.margins: 2
                cellWidth: width / 3
                cellHeight: 30
                boundsBehavior: Flickable.StopAtBounds
                activeFocusOnTab: true
                focus: true
                clip: true
                model: tmpGroupModel

                delegate: StyledCheckDelegate {
                    id: groupSelect
                    property int group_Id: group_id
                    text: group_name
                    checked: group_checked
                    onCheckedChanged: tmpGroupModel.setProperty(index, "group_checked", checked)
                }
            }
        }

        OkCancelButtons {
            onCancelled: pupilsToGroupsDialog.close()
            onValidated: pupilsToGroupsDialog.validateDialog()
        }

        Keys.onEscapePressed: pupilsToGroupsDialog.close()
        Keys.onReturnPressed: pupilsToGroupsDialog.validateDialog()
    }
}
