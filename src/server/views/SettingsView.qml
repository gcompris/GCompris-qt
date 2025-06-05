/* GCompris - SettingsView.qml
 *
 * SPDX-FileCopyrightText: 2023 Bruno Anselme <be.root@free.fr>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import core 1.0

import "../singletons"
import "../components"

Item {
    id: settingsView
    property var hostInformations: ({})
    property int labelWidth: 16 * Style.textSize
    property int infoWidth: mainColumn.width - labelWidth - Style.margins

    File { id: file }

    Image {
        id: logo
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: Style.margins
        source: 'qrc:/gcompris/src/server/resource/gcompris-icon.png'
    }

    TabBar {
        id: buttonBar
        anchors.top: logo.bottom
        anchors.left: logo.left
        anchors.right: logo.right
        anchors.margins: Style.margins
        background: Item {}
        spacing: Style.margins
        currentIndex: 0
        implicitWidth: logo.width

        contentItem: ListView {
            model: buttonBar.contentModel
            currentIndex: buttonBar.currentIndex
            width: childrenRect.width
            height: childrenRect.height
            spacing: buttonBar.spacing
            orientation: ListView.Vertical
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.AutoFlickIfNeeded
            snapMode: ListView.SnapToItem

            // highlightMoveDuration: 0
            // highlightRangeMode: ListView.ApplyRange
            // preferredHighlightBegin: 40
            // preferredHighlightEnd: height - 40
        }

        StyledTabButton {
            width: buttonBar.width
            text: qsTr("Settings")
            onClicked: swipe.currentIndex = 0
        }
        StyledTabButton {
            width: buttonBar.width
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
        currentIndex: buttonBar.currentIndex

        SplitView { // First item in SwipeView
            id: splitSettings

            ScrollView {
                id: scrollInfos
                SplitView.fillWidth: true
                SplitView.fillHeight: true
                Column {
                    id: mainColumn
                    x: Style.margins
                    width: splitSettings.width * 0.75 // TODO refactor that part properly...
                    height: childrenRect.height
                    spacing: Style.margins

                    Item {
                        width: 1
                        height: Style.hugeMargins
                    }

                    Row {
                        spacing: Style.margins

                        DefaultLabel {
                            width: settingsView.labelWidth
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Server ID")
                            font.bold: true
                        }

                        UnderlinedTextInput {
                            id: serverID
                            width: settingsView.infoWidth
                            activeFocusOnTab: true
                            focus: true
                            defaultText: serverSettings.serverID
                            onTextChanged: serverSettings.serverID = serverID.text
                        }
                    }
                    Row {
                        spacing: Style.margins

                        DefaultLabel {
                            width: settingsView.labelWidth
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Port")
                            font.bold: true
                        }

                        UnderlinedTextInput {
                            id: portField
                            width: settingsView.infoWidth
                            activeFocusOnTab: true
                            focus: true
                            defaultText: serverSettings.port
                            onTextChanged: serverSettings.port = portField.text
                        }
                    }

                    InformationLine {
                        label: qsTr("Server is")
                        info: serverRunning ? qsTr("Running") : qsTr("Already running on port %1").arg(serverSettings.port)
                        textColor: serverRunning ? "green" : "red"
                    }
                    InformationLine { label: qsTr("Host name"); info: settingsView.hostInformations.hostName }
                    InformationLine { label: qsTr("Server IP"); info: settingsView.hostInformations.ip.join(", ") }
                    InformationLine { label: qsTr("Broadcast IPs"); info: settingsView.hostInformations.broadcastIp.join(", ") }
                    InformationLine { label: qsTr("Netmask"); info: settingsView.hostInformations.netmask.join(", ") }
                    InformationLine { label: qsTr("MAC address"); info: settingsView.hostInformations.mac.join(", ") }
                    InformationLine { label: qsTr("Qt version"); info: ApplicationInfo.QTVersion }

                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "black" }

                    InformationLine { label: qsTr("Teacher login"); info: serverSettings.lastLogin }
                    InformationLine { label: qsTr("Database file"); info: userDataPath + "/" + databaseFile }
                    InformationLine { label: qsTr("Crypted database"); info: (databaseController) ? databaseController.isCrypted() ? qsTr("Yes") : qsTr("No") : ""}
                    InformationLine { label: qsTr("Pupils"); info: Master.userModel.count }
                    InformationLine { label: qsTr("Groups"); info: Master.groupModel.count }

                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "black" }

                    InformationLine { label: qsTr("Pupils connected"); info: (networkController) ? networkController.socketCount : 0}
                    InformationLine { label: qsTr("Pupils logged"); info: (networkController) ? networkController.loggedCount : 0 }
                    InformationLine { label: qsTr("Activities data received"); info: (networkController) ? networkController.dataCount : 0 }

                    Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: "black" }

                    RadioButtonLine {
                        title.width: settingsView.labelWidth
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
                        title.width: settingsView.labelWidth
                        label: qsTr("Font pixel size")
                        radios: [12, 14, 16, 18, 20]
                        current: radios.indexOf(Style.textSize)
                        onRadioCheckChanged: (index) => { Style.textSize = radios[index] }
                    }

                    Item {
                        width: 1
                        height: Style.hugeMargins
                    }
                }
            }

            ColumnLayout {
                id: activitiesColumn
                SplitView.preferredWidth: 200
                SplitView.minimumWidth: 100
                SplitView.maximumWidth: childrenRect.width
                SplitView.fillHeight: true

                Text {
                    Layout.leftMargin: 10
                    Layout.preferredHeight: Style.lineHeight
                    Layout.fillWidth: true
                    text: qsTr("%1 available activities").arg(Master.availableActivities.length)
                    font.pixelSize: Style.textSize
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: Style.selectedPalette.text
                }

                ScrollView {
                    Layout.fillHeight: true
                    Layout.leftMargin: 10
                    ColumnLayout {
                        spacing: 2
                        Repeater {
                            model: Master.availableActivities
                            Text {
                                height: Style.lineHeight
                                text: ((modelData !== undefined)
                                       && (Master.allActivities[modelData] !== undefined))
                                      ? Master.allActivities[modelData].title : ""
                                font.pixelSize: Style.textSize
                                horizontalAlignment: Text.AlignHCenter
                                color: Style.selectedPalette.text
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
            color: Style.selectedPalette.base
            ScrollView {  // Second item in SwipeView
                anchors.fill: parent
                Text {
                    id: helpText
                    anchors.fill: parent
                    anchors.margins: 10
                    anchors.centerIn: parent
                    text: "Help page"
                    textFormat: Text.RichText
                    color: Style.selectedPalette.text
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
