/* GCompris - SendDatasetDialog.qml
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

import core 1.0

import "../singletons"
import "../components"

Popup {
    id: sendDatasetDialog

    property bool sendMode: true        // send dataset or remove dataset from pupil

    property var datasetToSend
    anchors.centerIn: Overlay.overlay
    width: 600
    height: 500
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    ListModel { id: pupilModel }
    ListModel { id: tmpGroupModel }

    function openDatasetDialog(dataset, mode) {
        datasetToSend = dataset
        sendMode = mode
        // print("JJ openDatasetDialog", JSON.stringify(datasetToSend), sendMode)
        open()
    }

    onAboutToShow: {
        pupilModel.clear()
        for(var i = 0 ; i < Master.filteredUserModel.count ; i ++) {
            var user = Master.filteredUserModel.get(i)
            if (user.user_status === NetConst.CONNECTED) {
                pupilModel.append(user)
            }
        }
    }

    function validateDialog() {
        if(sendMode) {
            networkController.sendDatasetToUsers(datasetToSend, {})
        }
        else {
            networkController.removeDatasetToUsers(datasetToSend, {})
        }
        sendDatasetDialog.close()
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
            text: sendDatasetDialog.sendMode ? qsTr("Do you want to send the dataset to the selected users?")
            : qsTr("Are you sure you want to remove the dataset for the following users?")
            font {
                bold: true
                pixelSize: 20
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
                model: pupilModel

                delegate: CheckDelegate {
                    id: groupSelect
                    //property int group_Id: group_id
                    background: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: parent.activeFocus ? "darkgray" : "transparent"
                    }
                    text: user_name
                    checked: user_checked
                    //onCheckedChanged: tmpGroupModel.setProperty(index, "group_checked", checked)
                }
            }
        }

        OkCancelButtons {
            onCancelled: sendDatasetDialog.close()
            onValidated: sendDatasetDialog.validateDialog()
        }

        Keys.onReturnPressed: sendDatasetDialog.validateDialog()
        Keys.onEscapePressed: sendDatasetDialog.close()
    }
}
