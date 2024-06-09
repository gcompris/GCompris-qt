/* GCompris - SettingsView.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Basic

import GCompris 1.0
import "../singletons"
import "../components"

Item {
    property var hostInformations: ({})
    property int labelWidth: 16 * Style.defaultPixelSize
    property int infoWidth: scrollInfos.width - labelWidth - (2 * mainColumn.anchors.margins)

    File { id: file }

    Image {
        id: logo
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
        source: 'qrc:/gcompris/src/server/resource/gcompris-icon.png'
    }

    Column {
        id: buttonsColumn
        anchors.top: logo.bottom
        anchors.left: logo.left
        anchors.right: logo.right
        anchors.margins: 10
        spacing: 10
        Button {
            width: parent.width
            text: qsTr("Settings")
            onClicked: swipe.currentIndex = 0
        }
        Button {
            width: parent.width
            text: qsTr("Help")
            onClicked: swipe.currentIndex = 1
        }
    }

    SwipeView {
        id: swipe
        anchors.top: parent.top
        anchors.left: logo.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        clip: true

        SplitView { // First item in SwipeView
            id: splitSettings
            anchors.margins: 3

            ScrollView {
                id: scrollInfos
                SplitView.minimumWidth: 400
                SplitView.fillWidth: true
                SplitView.fillHeight: true
                ColumnLayout {
                    id: mainColumn
                    spacing: 2
                    anchors.fill: parent
                    anchors.margins: 10

                    Row {
                        Layout.preferredHeight: 30
                        Text {
                            height: parent.height
                            width: labelWidth
                            text: qsTr("Server ID")
                            verticalAlignment: Text.AlignVCenter
                            font.bold: true
                            font.pixelSize: Style.defaultPixelSize + 1
                        }

                        UnderlinedTextInput {
                            id: serverID
                            height: parent.height
                            width: infoWidth
                            activeFocusOnTab: true
                            focus: true
                            defaultText: serverSettings.serverID
                            onTextChanged: serverSettings.serverID = serverID.text
                        }
                    }

                    InformationLine {
                        label: qsTr("Server is")
                        info: serverRunning ? qsTr("Running") : qsTr("already running on port 5678")
                        textColor: serverRunning ? "green" : "red"
                    }
                    InformationLine { label: qsTr("Host name"); info: hostInformations.hostName }
                    InformationLine { label: qsTr("Server IP"); info: hostInformations.ip.join(", ") }
                    InformationLine { label: qsTr("Broadcast IPs"); info: hostInformations.broadcastIp.join(", ") }
                    InformationLine { label: qsTr("Netmask"); info: hostInformations.netmask.join(", ") }
                    InformationLine { label: qsTr("MAC address"); info: hostInformations.mac.join(", ") }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "black" }

                    InformationLine { label: qsTr("Teacher login"); info: serverSettings.lastLogin }
                    InformationLine { label: qsTr("Database file"); info: userDataPath + "/" + databaseFile }
                    InformationLine { label: qsTr("Crypted database"); info: (databaseController) ? databaseController.isCrypted() ? qsTr("Yes") : qsTr("No") : ""}
                    InformationLine { label: qsTr("Pupils"); info: Master.userModel.count }
                    InformationLine { label: qsTr("Groups"); info: Master.groupModel.count }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "black" }

                    InformationLine { label: qsTr("Pupils connected"); info: (networkController) ? networkController.socketCount : 0}
                    InformationLine { label: qsTr("Pupils logged"); info: (networkController) ? networkController.loggedCount : 0 }
                    InformationLine { label: qsTr("Activities data received"); info: (networkController) ? networkController.dataCount : 0 }

                    Rectangle { Layout.fillWidth: true; height: 1; color: "black" }

                    RadioButtonLine {
                        label: qsTr("Navigation panel")
                        radios: [qsTr("Left"), qsTr("Right")]
                        current: serverSettings.navigationPanelRight ? 1 : 0
                        onRadioCheckChanged: {
                            navigationBar.isCollapsed = false
                            serverSettings.navigationPanelRight = (current === 1) ? true : false
                            navigationBar.isCollapsed = true
                        }
                    }

                    RadioButtonLine {
                        label: qsTr("Font pixel size")
                        radios: [11, 12, 13, 14, 15, 16, 17, 18]
                        current: radios.indexOf(Style.defaultPixelSize)
                        onRadioCheckChanged: Style.defaultPixelSize = radios[index]
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 10
                        color: "transparent"
                    }
                }
            }

            ColumnLayout {
                SplitView.preferredWidth: 250
                SplitView.minimumWidth: 200
                SplitView.fillHeight: true

                Text {
                    Layout.leftMargin: 10
                    Layout.preferredHeight: Style.defaultLineHeight
                    Layout.fillWidth: true
                    text: qsTr("%1 available activities").arg(Master.availableActivities.length)
                    font.pixelSize: Style.defaultPixelSize
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                ScrollView {
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    ColumnLayout {
                        spacing: 2
                        Repeater {
                            model: Master.availableActivities
                            Text {
                                height: Style.defaultLineHeight
                                text: ((modelData !== undefined)
                                       && (Master.allActivities[modelData] !== undefined))
                                      ? Master.allActivities[modelData].title : ""
                                font.pixelSize: Style.defaultPixelSize
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.minimumHeight: 10
                    color: "transparent"
                }
            }
        }

        Rectangle { // Help page
            color: "white"
            border.width: 1
            ScrollView {  // Second item in SwipeView
                anchors.fill: parent
                Text {
                    id: helpText
                    anchors.fill: parent
                    anchors.margins: 10
                    anchors.centerIn: parent
                    text: "Help page"
                    textFormat: Text.RichText
                    font.family: Style.fontAwesome
                }
            }
        }
    }

    Component.onCompleted: {
        hostInformations = networkController.getHostInformations()
        splitSettings.restoreState(serverSettings.value("splitSettings"))
        helpText.text = file.read("qrc:/gcompris/src/server/help/help-fr.html")
    }
    Component.onDestruction: serverSettings.setValue("splitSettings", splitSettings.saveState())
}
