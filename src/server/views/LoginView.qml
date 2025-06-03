/* GCompris - LoginView.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Layouts 1.12
import core 1.0

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
//                navigationBar.startNavigation(navigationBar.activityDetails)
//                navigationBar.startNavigation(navigationBar.settingsView)
                navigationBar.startNavigation(navigationBar.datasetsView)
                Master.initialize()
            } else {
                message.text = qsTr("Incorrect password")
            }
            TopPanel.visible = true
            if (!serverRunning) {
                errorDialog.message = [qsTr("GCompris-teachers is already running on this computer")
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
        color: Style.selectedPalette.base

        Item {
            id: logoContainer
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: Math.max(parent.height * 0.33, logoImage.height + Style.hugeMargins * 2)
            Image {
                id: logoImage
                source: 'qrc:/gcompris/src/server/resource/gcompris-logo-full.svg'
                height: 180
                sourceSize.height: height
                anchors.centerIn: parent
            }
        }

        ColumnLayout {
            id: loginColumn
            Layout.alignment: Qt.AlignTop
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: logoContainer.bottom
            width: parent.width
            spacing: Style.margins

            DefaultLabel {
                id: loginLabel
                Layout.preferredHeight: Style.mediumTextSize
                Layout.fillWidth: true
                height: Style.mediumTextSize
                font.bold: true
                text: qsTr("Teacher login")
            }

            UnderlinedTextInput {
                id: login
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 320
                activeFocusOnTab: true
                focus: true
                defaultText: serverSettings.lastLogin
                onTextChanged: {
                    serverSettings.lastLogin = text
                    message.text = ""
                }
            }

            DefaultLabel {
                id: passwordLabel
                Layout.preferredHeight: Style.mediumTextSize
                Layout.fillWidth: true
                height: Style.mediumTextSize
                font.bold: true
                text: qsTr("Password")
            }

            UnderlinedTextInput {
                id: password
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 320
                activeFocusOnTab: true
                echoMode: TextInput.Password
                defaultText: serverSettings.lastLogin // TODO: set empty default text...
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 320
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

            DefaultLabel {
                id: message
                Layout.fillWidth: true
                Layout.preferredHeight: Style.textSize
                height: Style.textSize
                font.bold: true
                text: ""
            }

            DefaultLabel {
                id: databaseFileValue
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                Layout.preferredHeight: Style.textSize
                height: Style.textSize
                font.bold: true
                opacity: 0.5
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
        topBanner.text = qsTr("GCompris Teachers Tool")
        login.forceActiveFocus();
    }
}
