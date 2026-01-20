/* GCompris - DevicesView.qml
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

import core 1.0

import "../singletons"
import "../components"
import "../panels"

Item {
    id: devicesView
    width: parent.width
    height: parent.height

    property var hostInformations: ({})
    property var ipList: []
    property alias splitDevicesView: splitDevicesView
    enabled: serverRunning

    function setConnectionColor(status) {
        switch (status) {
        case NetConst.NOT_CONNECTED:
            return "transparent"
        case NetConst.BAD_PASSWORD_INPUT:
            return "#d94444" // red
        case NetConst.CONNECTED:
            return "#5cc854" // green
        case NetConst.CONNECTION_LOST:
            return "#e7bb36" // yellow
        case NetConst.DISCONNECTED:
            return Style.selectedPalette.accent
        default:
            return "black"      // Should never be black
        }
    }

    function setConnectionHelp(status) {
        switch (status) {
        case NetConst.NOT_CONNECTED:
            return qsTr("Not connected")
        case NetConst.BAD_PASSWORD_INPUT:
            return qsTr("Incorrect password")
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

    StyledSplitView {
        id: splitDevicesView
        anchors.fill: parent

        Connections {
            target: Master
            function onNetLog(message) { logPanel.appendLog(message) }
        }

        Connections {
            target: networkController
            function onNetLog(message) { logPanel.appendLog(message) }
        }

        FoldDown {
            id: groupPane
            SplitView.preferredWidth: splitDevicesView.width * 0.2
            SplitView.minimumWidth: splitDevicesView.width * 0.15
            title: qsTr("Groups")
            foldModel: Master.groupModel
            indexKey: "group_id"
            nameKey: "group_name"
            checkKey: "group_checked"
            delegateName: "radio"
            filterVisible: false
            collapsable: false
            onSelectionClicked: (modelId) => {
                if(visible) {
                    Master.setGroupFilterId(modelId);
                }
            }
        }

        FoldDown {
            id: pupilPane
            title: qsTr("Pupils")
            foldModel: Master.filteredUserModel
            indexKey: "user_id"
            nameKey: "user_name"
            checkKey: "user_checked"
            delegateName: "checkUserStatus"
            filterVisible: true
            collapsable: false
            SplitView.fillWidth: true
            SplitView.minimumWidth: splitDevicesView.width * 0.25
        }

        Item {
            id: networkColumn
            SplitView.preferredWidth: splitDevicesView.width * 0.3
            SplitView.minimumWidth: splitDevicesView.width * 0.25
            height: parent.height

            property int bigButtonWidth: Math.min(SplitView.minimumWidth - Style.bigMargins, 4 * Style.bigControlSize)
            property int bigButtonHeight: Math.min(height / (buttonsColumn.children.length - 3) - Style.margins, Style.bigControlSize)

            Rectangle {
                id: networkColumnTitle
                anchors.top: parent.top
                width: parent.width
                height: Style.lineHeight
                border.width: Style.defaultBorderWidth
                border.color: Style.selectedPalette.accent
                color: Style.selectedPalette.base

                DefaultLabel {
                    anchors.centerIn: parent
                    width: parent.width - Style.bigMargins
                    font.bold: true
                    text: qsTr("Network")
                    color: enabled ? Style.selectedPalette.text : "gray"
                }
            }

            Column {
                id: buttonsColumn
                anchors {
                    top: networkColumnTitle.bottom
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    margins: Style.margins
                }
                spacing: Style.margins

                property int labelWidth: (buttonsColumn.width - Style.margins) * 0.5

                ViewButton {
                    id: connectDevicesButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: networkColumn.bigButtonWidth
                    height: networkColumn.bigButtonHeight
                    text: qsTr("Connect devices")

                    onClicked: {
                        var ipList = hostInformations.broadcastIp
                        networkController.broadcastDatagram(ipList, serverSettings.serverID);
                    }
                }

                ViewButton {
                    id: loginListButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: networkColumn.bigButtonWidth
                    height: networkColumn.bigButtonHeight
                    text: qsTr("Send login list")
                    enabled: pupilPane.currentChecked != -1

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
                    }
                }

                ViewButton {
                    id: disconnectButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: networkColumn.bigButtonWidth
                    height: networkColumn.bigButtonHeight
                    text: qsTr("Disconnect selected pupils")
                    enabled: pupilPane.currentChecked != -1

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
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: networkColumn.bigButtonWidth
                    height: networkColumn.bigButtonHeight
                    text: qsTr("Disconnect everybody")

                    onClicked: {
                        networkController.disconnectPendingSockets()
                    }
                }

                Item {
                    height: Style.margins
                    width: 1
                }

                InformationLine {
                    labelWidth: buttonsColumn.labelWidth
                    infoWidth: buttonsColumn.labelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    label: qsTr("Server ID:")
                    info: serverSettings.serverID
                }
                InformationLine {
                    labelWidth: buttonsColumn.labelWidth
                    infoWidth: buttonsColumn.labelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    label: qsTr("Teacher port:")
                    info: serverSettings.port
                }
                InformationLine {
                    labelWidth: buttonsColumn.labelWidth
                    infoWidth: buttonsColumn.labelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    label: qsTr("Connected:")
                    info: (networkController) ? networkController.socketCount : 0
                }
                InformationLine {
                    labelWidth: buttonsColumn.labelWidth
                    infoWidth: buttonsColumn.labelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    label: qsTr("Logged:")
                    info: (networkController) ? networkController.loggedCount : 0
                }
                InformationLine {
                    labelWidth: buttonsColumn.labelWidth
                    infoWidth: buttonsColumn.labelWidth
                    anchors.horizontalCenter: parent.horizontalCenter
                    label: qsTr("Data received:")
                    info: (networkController) ? networkController.dataCount : 0
                }
            }
        }

        Item {
            id: logsColumn
            SplitView.preferredWidth: splitDevicesView.width * 0.2
            SplitView.minimumWidth: splitDevicesView.width * 0.1

            Rectangle {
                id: logsTitle
                anchors.top: parent.top
                width: parent.width
                height: Style.lineHeight
                border.width: Style.defaultBorderWidth
                border.color: Style.selectedPalette.accent
                color: Style.selectedPalette.base

                DefaultLabel {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        right: clearButton.left
                        margins: Style.margins
                    }
                    font.bold: true
                    text: qsTr("Network logs")
                    color: enabled ? Style.selectedPalette.text : "gray"
                }

                SmallButton {
                    id: clearButton
                    width: height
                    height: parent.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    icon.source: "qrc:/gcompris/src/server/resource/icons/delete.svg"
                    toolTipOnHover: true
                    toolTipText: qsTr("Clear logs")
                    onClicked: logPanel.clearLog()
                }
            }

            LogPanel {
                id: logPanel
                width: parent.width
                anchors.top: logsTitle.bottom
                anchors.bottom: parent.bottom
                anchors.margins: Style.margins
            }
        }

    }

    Component.onCompleted: {
        hostInformations = networkController.getHostInformations()
        serverRunning = networkController.isRunning()
        if (!serverRunning)
            logPanel.appendLog(qsTr("Server already running on port %1").arg(serverSettings.port))
         splitDevicesView.restoreState(serverSettings.value("splitDevicesView"))
    }
    Component.onDestruction: serverSettings.setValue("splitDevicesView", splitDevicesView.saveState())
}
