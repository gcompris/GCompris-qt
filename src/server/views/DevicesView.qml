/* GCompris - DevicesView.qml
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
import QtQuick.Layouts 1.15

import GCompris 1.0

import "../singletons"
import "../components"
import "../panels"

Rectangle {
    id: devicesView
    property var hostInformations: ({})
    property var ipList: []
    property int labelWidth: buttonsColumn.width / 2
    property int infoWidth: buttonsColumn.width / 2
    property int lineHeight: Style.defaultLineHeight
    property alias splitDevicesView: splitDevicesView
    color: "transparent"
    enabled: serverRunning

    function setConnectionColor(status) {
        switch (status) {
        case NetConst.NOT_CONNECTED:
            return "white"
        case NetConst.BAD_PASSWORD_INPUT:
            return "red"
        case NetConst.CONNECTED:
            return "green"
        case NetConst.CONNECTION_LOST:
            return "yellow"
        case NetConst.DISCONNECTED:
            return "lightgray"
        default:
            return "black"      // Should never be black
        }
    }

    function setConnectionHelp(status) {
        switch (status) {
        case NetConst.NOT_CONNECTED:
            return qsTr("Not connected")
        case NetConst.BAD_PASSWORD_INPUT:
            return qsTr("Bad password input")
        case NetConst.CONNECTED:
            return qsTr("Logged")
        case NetConst.CONNECTION_LOST:
            return qsTr("Connection lost")
        case NetConst.DISCONNECTED:
            return qsTr("Disconnected")
        default:
            return qsTr("Unknown connection status")
        }
    }

    SplitView {
        id: splitDevicesView
        anchors.margins: 3
        anchors.fill: parent

        Connections {
            target: Master
            function onNetLog(message) { logPanel.appendLog(message) }
        }

        Connections {
            target: networkController
            function onNetLog(message) { logPanel.appendLog(message) }
        }

        FoldDownRadio {
            id: groupPane
            title: qsTr("Groups")
            foldModel: Master.groupModel
            indexKey: "group_id"
            nameKey: "group_name"
            checkKey: "group_checked"
            collapsable: false
            SplitView.preferredWidth: 200
            SplitView.minimumWidth: 150
            onSelectionClicked: (modelId) => {
                Master.groupFilterId = modelId
                Master.filterUsers(Master.filteredUserModel, false)
            }
        }

        FoldDownCheck {
            id: pupilPane
            title: qsTr("Pupils")
            foldModel: Master.filteredUserModel
            indexKey: "user_id"
            nameKey: "user_name"
            checkKey: "user_checked"
            delegateName: "checkUserStatus"
            collapsable: false
            SplitView.fillWidth: true
            SplitView.minimumWidth: 300
        }

        Rectangle {
            id: buttonsColumn
            SplitView.preferredWidth: 250
            SplitView.minimumWidth: 250
            SplitView.maximumWidth: 350
            SplitView.fillHeight: true
            color: Style.colorBackground

            ColumnLayout {
                anchors.fill: parent
                spacing: 15

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Style.defaultLineHeight
                    color: Style.colorHeaderPane
                    radius: 5
                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Style.defaultPixelSize
                        font.bold: true
                        text: qsTr("Network")
                        color: enabled ? "black": "gray"
                    }
                }

                ViewButton {
                    id: connectDevicesButton
                    Layout.topMargin: 20
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: qsTr("Connect devices")

                    onClicked: {
                        var ipList = hostInformations.broadcastIp
                        networkController.broadcastDatagram(ipList, serverSettings.serverID);
                    }
                }

                ViewButton {
                    id: loginListButton
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: qsTr("Send login list")

                    onClicked: {
                        var usersList = [];         // selected users
                        var usersAll = []           // all users
                        for(var i = 0 ; i < Master.filteredUserModel.count; ++ i) {
                            var user = Master.filteredUserModel.get(i)
                            if ((user.user_status !== NetConst.CONNECTED) && (user.user_status !== NetConst.CONNECTION_LOST)) {
                                usersAll.push(user.user_name);
                                if (user.user_checked)
                                    usersList.push(user.user_name);
                            }
                        }
                        if (usersList.length > 0)
                            networkController.sendLoginList(usersList);
                        else
                            networkController.sendLoginList(usersAll);
                    }
                }

                ViewButton {
                    id: disconnectButton
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: qsTr("Disconnect selected pupils")

                    onClicked: {
                        var usersList = [];
                        for(var i = 0 ; i < Master.filteredUserModel.count ; ++ i) {
                            if (Master.filteredUserModel.get(i).user_checked) {
                                networkController.disconnectSession(Master.filteredUserModel.get(i).user_id);
                            }
                        }
                    }
                }

                ViewButton {
                    id: disconnectAllButton
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 200
                    text: qsTr("Disconnect everybody")

                    onClicked: {
                        networkController.disconnectPendingSockets()
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    Layout.margins: 5
                    InformationLine { label: qsTr("Server ID:"); info: serverSettings.serverID }
                    InformationLine { label: qsTr("Connected:"); info: (networkController) ? networkController.socketCount : 0}
                    InformationLine { label: qsTr("Logged:"); info: (networkController) ? networkController.loggedCount : 0 }
                    InformationLine { label: qsTr("Data received:"); info: (networkController) ? networkController.dataCount : 0 }
                }

                Rectangle {
                    Layout.preferredWidth: parent.width
                    Layout.preferredHeight: parent.height
                    color: "transparent"
                }
            }
        }

        ColumnLayout {
            spacing: 5
            SplitView.preferredWidth: 300
            SplitView.minimumWidth: 100

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Style.defaultLineHeight
                color: Style.colorHeaderPane
                radius: 5
                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Style.defaultPixelSize
                    font.bold: true
                    text: qsTr("Network logs")
                    color: enabled ? "black": "gray"
                }
                SmallButton {
                    width: Style.defaultLineHeight
                    height: Style.defaultLineHeight
                    anchors.top: parent.top
                    anchors.right: parent.right
                    font.pixelSize: Style.defaultPixelSize
                    text: "\uf1f8"
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Clear logs")
                    onClicked: logPanel.clearLog()
                }
            }
            LogPanel {
                id: logPanel
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    Component.onCompleted: {
        hostInformations = networkController.getHostInformations()
        serverRunning = networkController.isRunning()
        if (!serverRunning)
            logPanel.appendLog(qsTr("Server already running on port 5678"))
         splitDevicesView.restoreState(serverSettings.value("splitDevicesView"))
    }
    Component.onDestruction: serverSettings.setValue("splitDevicesView", splitDevicesView.saveState())
}
