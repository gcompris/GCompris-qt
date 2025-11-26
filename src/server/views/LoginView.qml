/* GCompris - LoginView.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import core 1.0

import "../components"
import "../singletons"
import "../dialogs"
import "../panels"

Item {
    id: dashboardView
    width: parent.width
    height: parent.height

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
                navigationBar.startNavigation(navigationBar.deviceView)
//                navigationBar.startNavigation(navigationBar.activitiesView)
               // navigationBar.startNavigation(navigationBar.datasetsView)
//                navigationBar.startNavigation(navigationBar.chartsView)
//                navigationBar.startNavigation(navigationBar.settingsView)
                // navigationBar.startNavigation(navigationBar.devView)
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
            mainStack.children[mainStack.currentIndex].focus = true
        } else {
            console.warn("Database", databaseFile, "doesn't exist in", userDataPath)
        }
    }

    CreateDbDialog { id: createDb }

    Item {
        id: logoContainer
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: loginColumn.top
            margins: Style.bigMargins
        }

        Image {
            id: logoImage
            source: 'qrc:/gcompris/src/server/resource/gcompris-logo-full.svg'
            height: Math.min(180, parent.height)
            sourceSize.height: height
            anchors.centerIn: parent
        }
    }

    Column {
        id: loginColumn
        anchors.centerIn: parent
        anchors.verticalCenterOffset: Style.hugeMargins
        width: parent.width
        spacing: Style.margins

        DefaultLabel {
            id: loginLabel
            width: parent.width
            height: Style.mediumTextSize
            font.bold: true
            text: qsTr("Teacher login")
        }

        UnderlinedTextInput {
            id: login
            anchors.horizontalCenter: parent.horizontalCenter
            width: 320
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
            width: parent.width
            height: Style.mediumTextSize
            font.bold: true
            text: qsTr("Password")
        }

        UnderlinedTextInput {
            id: password
            anchors.horizontalCenter: parent.horizontalCenter
            width: 320
            activeFocusOnTab: true
            echoMode: TextInput.Password
            defaultText: serverSettings.lastLogin // TODO: set empty default text...
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Style.margins
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
            width: parent.width
            font.bold: true
            text: ""
        }

        DefaultLabel {
            id: databaseFileValue
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            font.bold: true
            fontSizeMode: Text.Fit
            opacity: 0.5
            text: qsTr("Database file:") + " " + userDataPath + "/"+ databaseFile
        }
    }

    Keys.onReturnPressed: {
        if(connectTeacherButton.enabled) {
            connectTeacher();
        } else if(createTeacherButton.enabled) {
            createDb.open();
        }
    }

    Component.onCompleted: {
        topBanner.text = qsTr("GCompris Teachers Tool");
        login.forceActiveFocus();
    }
}
