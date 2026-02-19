/* GCompris - PupilsToGroupsDialog.qml
 *
 * SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../singletons"
import "../components"

Popup {
    id: pupilsToGroupsDialog

    property bool addMode: true        // add pupil or remove pupil mode

    anchors.centerIn: Overlay.overlay
    width: dialogColumn.childrenRect.width + 2 * padding
    height: dialogColumn.childrenRect.height + 2 * padding
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    // popupType: Popup.Item // TODO: uncomment when min Qt version >= 6.8

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
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.text
        border.width: Style.defaultBorderWidth
    }

    Column {
        id: dialogColumn
        width: 780
        height: childrenRect.height
        anchors.centerIn: parent
        spacing: Style.margins

        DefaultLabel {
            id: deletePupilGroupsText
            width: parent.width
            height: Style.mediumTextSize
            fontSizeMode: Text.Fit
            font.bold: true
            text: pupilsToGroupsDialog.addMode ? qsTr("Select the groups to add these pupils to:")
                                    : qsTr("Select the groups from which to remove these pupils:")
        }

        Item {
            width: 1
            height: Style.margins
        }

        Rectangle {
            id: pupilsNamesTextRectangle
            width: parent.width
            height: 200
            color: Style.selectedPalette.alternateBase

            GridView {
                id: pupilsGrid
                anchors.fill: parent
                anchors.margins: Style.margins
                cellWidth: width * 0.25
                cellHeight: Style.mediumLineHeight
                boundsBehavior: Flickable.StopAtBounds
                pixelAligned: true
                clip: true
                model: pupilModel
                delegate: Item {
                    width: pupilsGrid.cellWidth
                    height: pupilsGrid.cellHeight
                    DefaultLabel {
                        width: parent.width - Style.margins
                        text: user_name
                        anchors.centerIn: parent
                    }
                }
            }
        }

        Rectangle {
            id: groupNamesRectangle
            width: parent.width
            height: 200
            border.color: Style.selectedPalette.accent
            border.width: 1
            color: Style.selectedPalette.alternateBase

            GridView {
                id: groupNamesListView
                anchors.fill: parent
                anchors.margins: Style.margins
                cellWidth: width / 3
                cellHeight: Style.mediumLineHeight
                boundsBehavior: Flickable.StopAtBounds
                pixelAligned: true
                activeFocusOnTab: true
                focus: true
                clip: true
                model: tmpGroupModel
                delegate: StyledCheckBox {
                    id: groupSelect
                    property int group_Id: group_id
                    width: groupNamesListView.cellWidth - Style.margins
                    text: group_name
                    checked: group_checked
                    onCheckedChanged: tmpGroupModel.setProperty(index, "group_checked", checked)
                }
            }
        }

        OkCancelButtons {
            anchors.horizontalCenter: parent.horizontalCenter
            onCancelled: pupilsToGroupsDialog.close()
            onValidated: pupilsToGroupsDialog.validateDialog()
        }

        Keys.onEscapePressed: pupilsToGroupsDialog.close()
        Keys.onReturnPressed: pupilsToGroupsDialog.validateDialog()
    }
}
