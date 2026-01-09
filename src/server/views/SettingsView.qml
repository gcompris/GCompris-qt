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
    width: parent.width
    height: parent.height

    property var hostInformations: ({})

    property var languages: allLangs.languages

    ServerLanguageList {
        id: allLangs
    }

    Rectangle {
        id: topLiner
        width: parent.width
        height: Style.defaultBorderWidth
        color: Style.selectedPalette.accent
    }

    StyledFlickable {
        id: scrollInfos
        anchors.fill: parent
        anchors.topMargin: topLiner.height
        contentHeight: Math.max(height, mainColumn.height)
        contentWidth: mainColumn.width + 2 * Style.margins

        Rectangle {
            id: labelArea
            width: Math.min(20 * Style.textSize,
                            scrollInfos.width * 0.35)
            height: scrollInfos.contentHeight
            color: Style.selectedPalette.alternateBase
        }

        Column {
            id: mainColumn
            x: Style.margins
            width: implicitWidth
            height: implicitHeight
            spacing: Style.margins

            property int infoWidth: scrollInfos.width - labelArea.width - 4 * Style.margins

            RadioButtonLine {
                title.width: labelArea.width + Style.margins
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
                title.width: labelArea.width + Style.margins
                label: qsTr("Font size")
                radios: [12, 14, 16, 18, 20]
                current: radios.indexOf(Style.textSize)
                onRadioCheckChanged: (index) => {
                    serverSettings.textSize = radios[index];
                }
            }

            RadioButtonLine {
                title.width: labelArea.width + Style.margins
                label: qsTr("Theme")
                radios: [qsTr("Dark"), qsTr("Light")]
                current: serverSettings.darkTheme ? 0 : 1
                onRadioCheckChanged: {
                    serverSettings.darkTheme = (current === 1) ? false : true
                }
            }

            Row {
                spacing: Style.margins
                height: Style.lineHeight

                DefaultLabel {
                    width: labelArea.width
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    text: qsTr("Language selector")
                    font.bold: true
                }

                StyledComboBox {
                    id: language
                    model: settingsView.languages
                    width: mainColumn.infoWidth
                    textRole: "text"
                    valueRole: "locale"
                    onSelectIndex: (selectedIndex) => {
                        Master.locale = language.valueAt(language.currentIndex);
                        // We need to restore the current index because after setting the locale
                        // the retranslation of the engine resets the value to 0
                        language.currentIndex = indexOfValue(serverSettings.locale)
                    }

                    onCheckedChanged: {
                        if(checked) {
                            scrollInfos.interactive = false;
                        } else {
                            scrollInfos.interactive = true;
                        }
                    }

                    Component.onCompleted: {
                        currentIndex = indexOfValue(serverSettings.locale);
                    }
                }
            }

            Rectangle {
                id: lineSpacer
                width: scrollInfos.width - 2 * Style.margins
                height: Style.defaultBorderWidth
                color: Style.selectedPalette.accent
            }

            Row {
                spacing: Style.margins
                height: Style.lineHeight

                DefaultLabel {
                    width: labelArea.width
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
                    width: labelArea.width
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
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Server status")
                info: serverRunning ? qsTr("Running", "As in 'The server is running'") : qsTr("Already running on port %1", "As in 'The Server is already running on port %1'").arg(serverSettings.port)
                showResult: true
                resultSuccess: serverRunning
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Host name")
                info: settingsView.hostInformations.hostName
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Server IP")
                info: settingsView.hostInformations.ip.join(", ")
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Broadcast IPs")
                info: settingsView.hostInformations.broadcastIp.join(", ")
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Netmask")
                info: settingsView.hostInformations.netmask.join(", ")
            }

            InformationLine {
                label: qsTr("MAC address")
                info: settingsView.hostInformations.mac.join(", ")
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("GCompris version")
                info: ApplicationInfo.GCVersion
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Qt version")
                info: ApplicationInfo.QTVersion
            }

            Rectangle {
                width: lineSpacer.width
                height: Style.defaultBorderWidth
                color: Style.selectedPalette.accent
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Teacher login")
                info: serverSettings.lastLogin
            }

            InformationLine {
                id: databaseInfoline
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Database file")
                info: userDataPath + "/" + databaseFile
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Encrypted database")
                info: (databaseController && databaseController.isCrypted) ? qsTr("Yes") : qsTr("No")
            }
            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Pupils")
                info: Master.userModel.count
            }
            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Groups")
                info: Master.groupModel.count
            }

            Rectangle {
                width: lineSpacer.width
                height: Style.defaultBorderWidth
                color: Style.selectedPalette.accent
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Pupils connected")
                info: (networkController) ? networkController.socketCount : 0
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Pupils logged")
                info: (networkController) ? networkController.loggedCount : 0
            }

            InformationLine {
                labelWidth: labelArea.width
                infoText.width: infoText.implicitWidth
                label: qsTr("Activities data received")
                info: (networkController) ? networkController.dataCount : 0
            }

            Item {
                width: 1
                height: Style.hugeMargins
            }
        }
    }

    Component.onCompleted: {
        hostInformations = networkController.getHostInformations()
    }
}
