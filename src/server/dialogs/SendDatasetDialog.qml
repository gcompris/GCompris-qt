/* GCompris - SendDatasetDialog.qml
*
* SPDX-FileCopyrightText: 2021 Johnny Jazeix <jazeix@gmail.com>
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

import core 1.0

import "../singletons"
import "../components"

Popup {
    id: sendDatasetDialog
    enum MessageType { Send, Remove, RemoveAll }
    property int messageType: SendDatasetDialog.MessageType.Send

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
        messageType = mode
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
        var users = [];
        // Retrieve checked users
        for(var i = 0 ; i < pupilModel.count ; i ++) {
            var user = pupilModel.get(i)
            if(user.user_checked) {
                users.push(user.user_id);
            }
        }
        switch(messageType) {
            case SendDatasetDialog.MessageType.Send:
            networkController.sendDatasetToUsers(datasetToSend, users)
            break;
            case SendDatasetDialog.MessageType.Remove:
            networkController.removeDatasetToUsers(datasetToSend, users)
            break;
            case SendDatasetDialog.MessageType.RemoveAll:
            networkController.removeAllDatasetsToUsers(users)
            break;
        }
        sendDatasetDialog.close()
    }

    background: Rectangle {
        color: Style.selectedPalette.base
        radius: Style.defaultRadius
        border.color: Style.selectedPalette.accent
        border.width: Style.defaultBorderWidth
    }

    Item {
        id: focusItem
        anchors.fill: parent

        DefaultLabel {
            id: titleText
            width: parent.width
            height: implicitHeight
            font.pixelSize: Style.textSize
            font.bold: true
            wrapMode: Text.WordWrap
            text: sendDatasetDialog.messageType === SendDatasetDialog.MessageType.Send ? qsTr("Do you want to send the dataset to selected pupils?")
            : sendDatasetDialog.messageType === SendDatasetDialog.MessageType.Remove ? qsTr("Are you sure you want to remove the dataset from selected pupils?")
            : qsTr("Are you sure you want to remove all the existing datasets from selected pupils?")
        }

        Rectangle {
            id: listHeader
            width: parent.width
            height: Style.lineHeight
            color: Style.selectedPalette.base
            border.width: Style.defaultBorderWidth
            border.color: Style.selectedPalette.accent
            anchors.top: titleText.bottom
            anchors.topMargin: Style.margins

            StyledCheckBox {
                id: checkAllButton
                anchors.left: parent.left
                anchors.margins: Style.margins
                linkedGroup: pupilButtonsGroup
            }

            ButtonGroup {
                id: pupilButtonsGroup
                exclusive: false
            }

            DefaultLabel {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: checkAllButton.right
                    right: parent.right
                    margins: Style.margins
                }
                horizontalAlignment: Text.AlignLeft
                font.bold: true
                text: qsTr("Pupils")
            }
        }

        Rectangle {
            id: groupNamesRectangle
            width: parent.width
            anchors.top: listHeader.bottom
            anchors.bottom: bottomButtons.top
            anchors.bottomMargin: Style.margins
            color: Style.selectedPalette.alternateBase

            ListView {
                id: groupNamesListView
                anchors.fill: parent
                anchors.margins: Style.margins
                boundsBehavior: Flickable.StopAtBounds
                contentWidth: width
                contentHeight: childrenRect.height
                activeFocusOnTab: true
                focus: true
                clip: true
                model: pupilModel
                pixelAligned: true

                ScrollBar.vertical: ScrollBar {
                    contentItem: Rectangle {
                        implicitWidth: 6
                        radius: width
                        visible: groupNamesListView.contentHeight > groupNamesListView.height
                        color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
                    }
                }

                delegate: StyledCheckBox {
                    id: groupSelect
                    width: groupNamesListView.width
                    text: user_name
                    checked: user_checked
                    onCheckedChanged: user_checked = checked
                    ButtonGroup.group: pupilButtonsGroup
                }
            }
        }

        OkCancelButtons {
            id: bottomButtons
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            onCancelled: sendDatasetDialog.close();
            onValidated: sendDatasetDialog.validateDialog();
        }

        Keys.onReturnPressed: bottomButtons.validated();
        Keys.onEscapePressed: bottomButtons.cancelled();
    }
}
