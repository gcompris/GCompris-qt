/* GCompris - LoginView.qml
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
import QtQuick.Layouts 1.12
import GCompris 1.0

import "../components"
import "../singletons"
import "../dialogs"
import "../panels"

Item {
    id: dashboardView

    function connectTeacher() {
        serverSettings.lastLogin = login.text
        var fileName = userDataPath + "/" + databaseFile
        if (Master.fileExists(fileName)) {
            Master.loadDatabase(fileName);
            if(Master.checkTeacher(login.text, password.text)) {
                console.warn(login.text, "logged in.")
                navigationBar.enabled = true
                topBanner.visible = true
//                navigationBar.startNavigation(navigationBar.pupilsView)
//                navigationBar.startNavigation(navigationBar.deviceView)
//                navigationBar.startNavigation(navigationBar.datasView)
//                navigationBar.startNavigation(navigationBar.chartsView)
                navigationBar.startNavigation(navigationBar.activityDetails)
//                navigationBar.startNavigation(navigationBar.settingsView)
                Master.initialize()
            } else {
                message.text = qsTr("Incorrect password")
            }
            TopPanel.visible = true
            if (!serverRunning) {
                errorDialog.message = [qsTr("GCompris-server is already running on this computer")
                                     , qsTr("Only data browsing is permitted")]
                errorDialog.open()
            }
            dashboardView.enabled = false
            navigationBar.loginButton.visible = false
            mainStack.children[mainStack.currentIndex].focus = true
        } else {
            console.warn("Database", databaseFile, "doesn't exist in", userDataPath)
        }
    }

    CreateDbDialog { id: createDb }

    Rectangle {
        anchors.fill: parent
        color: Style.colorBackground
        ColumnLayout {
            anchors.centerIn: parent
            width: 350
            spacing: 10
            Text {
                Layout.preferredHeight: 40
                Layout.fillWidth: true
                text: qsTr("GCompris-Server")
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font {
                    pixelSize: 25
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                Image {
                    source: 'qrc:/gcompris/src/server/resource/gcompris-icon.png'
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                }
                Image {
                    source: 'qrc:/gcompris/src/server/resource/aboutkde.png'
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                }
            }

            Text {
                id: loginLabel
                Layout.preferredHeight: 20
                Layout.fillWidth: true
                text: qsTr("Teacher login")
                font.bold: true
                font {
                    pixelSize: 15
                }
            }

            UnderlinedTextInput {
                id: login
                Layout.preferredHeight: Style.defaultLineHeight
                Layout.fillWidth: true
                activeFocusOnTab: true
                focus: true
                defaultText: serverSettings.lastLogin
                onTextChanged: {
                    serverSettings.lastLogin = text
                    message.text = ""
                }
            }

            Text {
                id: passwordLabel
                Layout.preferredHeight: 20
                Layout.fillWidth: true
                text: qsTr("Password")
                font.bold: true
                font {
                    pixelSize: 15
                }
            }

            UnderlinedTextInput {
                id: password
                Layout.preferredHeight: Style.defaultLineHeight
                Layout.fillWidth: true
                activeFocusOnTab: true
                echoMode: TextInput.Password
                defaultText: serverSettings.lastLogin
            }

            RowLayout {
                Layout.fillWidth: true
                ViewButton {
                    id: connectTeacherButton
                    activeFocusOnTab: true
                    text: qsTr("Login")
                    opacity: enabled ? 1.0 : 0.3
                    enabled: Master.fileExists(userDataPath + "/" + databaseFile)
                    onClicked: connectTeacher()
                }

                ViewButton {
                    id: createTeacherButton
                    activeFocusOnTab: true
                    text: qsTr("Create teacher database")
                    opacity: enabled ? 1.0 : 0.3
                    enabled: (!Master.fileExists(userDataPath + "/" + databaseFile)) && (login.text.length > 3)
                    onClicked: createDb.open()
                }
            }

            Text {
                id: message
                Layout.preferredHeight: 30
                Layout.fillWidth: true
                text: ""
                color: "transparent"
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 14
            }

            Text {
                id: databaseFileValue
                Layout.preferredHeight: 16
                Layout.fillWidth: true
                opacity: 0.3
                text: qsTr("Database file:") + " " + userDataPath + "/"+ databaseFile
            }
        }

        Keys.onReturnPressed: {
            if (connectTeacherButton.enabled)
                connectTeacher()
            else if (createTeacherButton.enabled)
                createDb.open()
        }
    }

    Component.onCompleted: {
        topBanner.text = qsTr("GCompris-Server login")
        login.forceActiveFocus();
    }
}
