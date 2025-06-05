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
import QtQuick.Controls.Basic
import core 1.0

import "../singletons"
import "../components"

Item {
    id: settingsView
    property var hostInformations: ({})

    File { id: file }

    Rectangle {
        id: leftArea
        color: Style.selectedPalette.alternateBase
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        width: buttonBar.width + 2 * Style.margins


        Image {
            id: logo
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            source: 'qrc:/gcompris/src/server/resource/gcompris-icon.png'
        }

        TabBar {
            id: buttonBar
            anchors.top: logo.bottom
            anchors.left: parent.left
            anchors.margins: Style.margins
            width: Math.max(128, logo.width)
            background: Item {}
            spacing: Style.margins
            currentIndex: 0
            implicitWidth: width

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
    }

    SwipeView {
        id: swipe
        anchors.top: parent.top
        anchors.left: leftArea.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        clip: true
        currentIndex: buttonBar.currentIndex

        StyledSplitView { // First item in SwipeView
            id: splitSettings

            Flickable {
                id: scrollInfos
                SplitView.fillWidth: true
                SplitView.fillHeight: true

                contentWidth: mainColumn.width
                contentHeight: mainColumn.height
                boundsBehavior: Flickable.StopAtBounds
                clip: true

                ScrollBar.horizontal: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    rightPadding: 10
                    contentItem: Rectangle {
                        implicitHeight: 6
                        radius: width
                        opacity: scrollInfos.contentWidth > scrollInfos.width ? 1 : 0
                        color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    bottomPadding: 10
                    contentItem: Rectangle {
                        implicitWidth: 6
                        radius: width
                        opacity: scrollInfos.contentHeight > scrollInfos.height ? 1 : 0
                        color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
                    }
                }

                Column {
                    id: mainColumn
                    x: Style.margins
                    width: implicitWidth
                    height: implicitHeight
                    spacing: Style.margins

                    property int idealWidth: scrollInfos.width - 3 * Style.margins
                    property int labelWidth: Math.min(20 * Style.textSize,
                                                      mainColumn.idealWidth * 0.35)
                    property int infoWidth: mainColumn.idealWidth - labelWidth - Style.margins

                    Item {
                        // This item makes sure that the view can be scrolled horizontally to view full name of database file
                        width: databaseInfoline.width + 2 * Style.margins
                        height: Style.hugeMargins
                    }

                    Row {
                        spacing: Style.margins
                        height: Style.lineHeight

                        DefaultLabel {
                            width: mainColumn.labelWidth
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Server ID")
                            font.bold: true
                        }

                        UnderlinedTextInput {
                            id: serverID
                            width: mainColumn.infoWidth
                            activeFocusOnTab: true
                            focus: true
                            defaultText: serverSettings.serverID
                            onTextChanged: serverSettings.serverID = serverID.text
                        }
                    }

                    Row {
                        spacing: Style.margins
                        height: Style.lineHeight

                        DefaultLabel {
                            width: mainColumn.labelWidth
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            text: qsTr("Port")
                            font.bold: true
                        }

                        UnderlinedTextInput {
                            id: portField
                            width: mainColumn.infoWidth
                            activeFocusOnTab: true
                            focus: true
                            defaultText: serverSettings.port
                            onTextChanged: serverSettings.port = portField.text
                        }
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Server is")
                        info: serverRunning ? qsTr("Running") : qsTr("Already running on port %1").arg(serverSettings.port)
                        textColor: serverRunning ? "green" : "red"
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Host name")
                        info: settingsView.hostInformations.hostName
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Server IP")
                        info: settingsView.hostInformations.ip.join(", ")
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Broadcast IPs")
                        info: settingsView.hostInformations.broadcastIp.join(", ")
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Netmask")
                        info: settingsView.hostInformations.netmask.join(", ")
                    }

                    InformationLine {
                        label: qsTr("MAC address")
                        info: settingsView.hostInformations.mac.join(", ")
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Qt version")
                        info: ApplicationInfo.QTVersion
                    }

                    Rectangle {
                        width: mainColumn.idealWidth
                        height: Style.defaultBorderWidth
                        color: Style.selectedPalette.accent
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Teacher login")
                        info: serverSettings.lastLogin
                    }

                    InformationLine {
                        id: databaseInfoline
                        labelWidth: mainColumn.labelWidth
                        // Don't restrict width to always allow viewing full name by scrolling horizontally
                        label: qsTr("Database file")
                        info: userDataPath + "/" + databaseFile
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Crypted database")
                        info: (databaseController) ?
                            (databaseController.isCrypted() ? qsTr("Yes") : qsTr("No"))
                            : ""
                    }
                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Pupils")
                        info: Master.userModel.count
                    }
                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Groups")
                        info: Master.groupModel.count
                    }

                    Rectangle {
                        width: mainColumn.idealWidth
                        height: Style.defaultBorderWidth
                        color: Style.selectedPalette.accent
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Pupils connected")
                        info: (networkController) ? networkController.socketCount : 0
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Pupils logged")
                        info: (networkController) ? networkController.loggedCount : 0
                    }

                    InformationLine {
                        labelWidth: mainColumn.labelWidth
                        infoWidth: mainColumn.infoWidth
                        label: qsTr("Activities data received")
                        info: (networkController) ? networkController.dataCount : 0
                    }

                    Rectangle {
                        width: mainColumn.idealWidth
                        height: Style.defaultBorderWidth
                        color: Style.selectedPalette.accent
                    }

                    RadioButtonLine {
                        title.width: mainColumn.labelWidth + Style.margins
                        label: qsTr("Menu panel")
                        radios: [qsTr("Left"), qsTr("Right")]
                        current: serverSettings.navigationPanelRight ? 1 : 0
                        onRadioCheckChanged: {
                            navigationBar.isCollapsed = false
                            serverSettings.navigationPanelRight = (current === 1) ? true : false
                            navigationBar.isCollapsed = true
                        }
                    }

                    RadioButtonLine {
                        title.width: mainColumn.labelWidth + Style.margins
                        label: qsTr("Font size")
                        radios: [12, 14, 16, 18, 20]
                        current: radios.indexOf(Style.textSize)
                        onRadioCheckChanged: (index) => { Style.textSize = radios[index] }
                    }

                    RadioButtonLine {
                        title.width: mainColumn.labelWidth + Style.margins
                        label: qsTr("Theme")
                        radios: [qsTr("Dark"), qsTr("Light")]
                        current: serverSettings.darkTheme ? 0 : 1
                        onRadioCheckChanged: {
                            serverSettings.darkTheme = (current === 1) ? false : true
                        }
                    }

                    Item {
                        width: 1
                        height: Style.hugeMargins
                    }
                }
            }

            Item {
                id: activitiesListArea
                SplitView.preferredWidth: Math.min(splitSettings.width * 0.3,
                    activitiesColumn.width)
                SplitView.minimumWidth: splitSettings.width * 0.1
                SplitView.maximumWidth: activitiesColumn.width
                SplitView.fillHeight: true

                Rectangle {
                    id: activitiesListTitle
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
                        text: qsTr("%1 available activities").arg(Master.availableActivities.length)
                    }
                }

                Flickable {
                    id: activitiesScroll
                    anchors {
                        top: activitiesListTitle.bottom
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    contentWidth: activitiesColumn.width
                    contentHeight: activitiesColumn.height
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true

                    ScrollBar.horizontal: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        rightPadding: 10
                        contentItem: Rectangle {
                            implicitHeight: 6
                            radius: width
                            opacity: activitiesScroll.contentWidth > activitiesScroll.width ? 1 : 0
                            color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        bottomPadding: 10
                        contentItem: Rectangle {
                            implicitWidth: 6
                            radius: width
                            opacity: activitiesScroll.contentHeight > activitiesScroll.height ? 1 : 0
                            color: parent.pressed ? Style.selectedPalette.highlight : Style.selectedPalette.button
                        }
                    }

                    Column {
                        id: activitiesColumn
                        width: childrenRect.width + 3 * Style.margins
                        height: childrenRect.height
                        spacing: Style.margins

                        Item {
                            width: 1
                            height: Style.margins
                        }

                        Repeater {
                            model: Master.availableActivities
                            DefaultLabel {
                                x: Style.margins
                                horizontalAlignment: Text.AlignLeft
                                text: ((modelData !== undefined) &&
                                    (Master.allActivities[modelData] !== undefined)) ?
                                            Master.allActivities[modelData].title : ""
                            }
                        }

                        Item {
                            width: 1
                            height: Style.hugeMargins
                        }
                    }
                }
            }
            Item {
                // just to make a visual border between SwipeView pages
                SplitView.maximumWidth: 0
                width: 1
                height: parent.height
            }
        }

        Item { // Help page

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
