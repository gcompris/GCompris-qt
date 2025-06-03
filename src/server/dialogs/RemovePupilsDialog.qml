/* GCompris - RemovePupilsDialog.qml
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
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.12

import "../singletons"
import "../components"

Popup {
    id: removePupilsDialog

    property string pupilsNamesText: ""
    property var pupilsNamesList: []
    property var pupilIds: []

    anchors.centerIn: Overlay.overlay
    width: 600
    height: 300
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    background: Rectangle {
        color: Style.selectedPalette.alternateBase
        radius: 5
        border.color: "darkgray"
        border.width: 2
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

    ColumnLayout {
        anchors.fill: parent
        anchors.centerIn: parent

        Text {
            id: deletePupilGroupsText
            Layout.fillWidth: true
            Layout.preferredHeight: 90
            Layout.preferredWidth: parent.width * 2/3
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("Are you sure you want to remove the following children from the database ?")
            font {
                bold: true
                pixelSize: 20
            }
            color: Style.selectedPalette.text
        }

        Rectangle {
            id: pupilsNamesTextRectangle
            Layout.fillWidth: true
            Layout.fillHeight: true
            border.color: "gray"
            border.width: 1

            GridView {
                anchors.fill: parent
                cellWidth: width / 4
                cellHeight: 20
                anchors.margins: 3
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                model: removePupilsDialog.pupilsNamesText.split("\n")

                delegate: Column {
                    Text {
                        text: modelData
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: Style.selectedPalette.text
                    }
                }
            }
        }

        OkCancelButtons {
            onCancelled: removePupilsDialog.close()
            onValidated: {
                removePupilsDialog.validateDialog()
                removePupilsDialog.close()
            }
        }
    }
}
