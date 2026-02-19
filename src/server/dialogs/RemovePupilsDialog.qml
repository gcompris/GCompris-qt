/* GCompris - RemovePupilsDialog.qml
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
import QtQuick.Controls.Basic

import "../singletons"
import "../components"

Popup {
    id: removePupilsDialog

    property string pupilsNamesText: ""
    property var pupilsNamesList: []
    property var pupilIds: []

    anchors.centerIn: Overlay.overlay
    width: dialogColumn.childrenRect.width + 2 * padding
    height: dialogColumn.childrenRect.height + 2 * padding
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    // popupType: Popup.Item // TODO: uncomment when min Qt version >= 6.8

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.text
        border.width: Style.defaultBorderWidth
    }

    function validateDialog() {
        console.warn(removePupilsDialog.pupilsNamesList.length, removePupilsDialog.pupilsNamesList)
        for(var i = 0 ; i < removePupilsDialog.pupilIds.length; i++) {
            Master.deleteUser(removePupilsDialog.pupilIds[i])
        }
        Master.loadUsers()
        Master.filterUsers(Master.filteredUserModel, false)
    }

    onAboutToShow: {
        pupilsNamesList = []
        pupilIds = []
        for(var i = 0 ; i < Master.filteredUserModel.count ; i ++) {
            var user = Master.filteredUserModel.get(i)
            if (user.user_checked === true) {
                pupilsNamesList.push(Master.filteredUserModel.get(i).user_name)
                pupilIds.push(Master.filteredUserModel.get(i).user_id)
            }
        }
        pupilsNamesText = pupilsNamesList.join("\n")
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
            text: qsTr("Are you sure you want to remove the following pupils from the database ?")
        }

        Item {
            width: 1
            height: Style.margins
        }

        Rectangle {
            id: pupilsNamesTextRectangle
            width: parent.width
            height: 400
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
                model: removePupilsDialog.pupilsNamesText.split("\n")
                delegate: Item {
                    width: pupilsGrid.cellWidth
                    height: pupilsGrid.cellHeight
                    DefaultLabel {
                        width: parent.width - Style.margins
                        text: modelData
                        anchors.centerIn: parent
                    }
                }
            }
        }

        OkCancelButtons {
            anchors.horizontalCenter: parent.horizontalCenter
            onCancelled: removePupilsDialog.close()
            onValidated: {
                removePupilsDialog.validateDialog()
                removePupilsDialog.close()
            }
        }
    }
}
