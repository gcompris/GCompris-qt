/* GCompris - Main.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno ANSELME <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml 2.12
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.15
import QtCore // For Settings and StandardPaths

import GCompris 1.0
import "qrc:/gcompris/src/server/server.js" as Server

import "components"
import "dialogs"
import "panels"
import "singletons"
import "views"

/**
 * GCompris' main QML file defining the top level window.
 * @ingroup infrastructure
 *
 * Handles application start (Component.onCompleted) and shutdown (onClosing)
 * on the QML layer.
 *
 * Contains the top level StackView presenting and animating GCompris-server'
 * full screen views.
 *
 * @inherit QtQuick.Window
 */
Window {
    id: mainWindow
    property string databaseFile: serverSettings.lastLogin + ".sqlite"
    property string userDataPath: (StandardPaths.writableLocation(StandardPaths.GenericDataLocation) + "/gcompris-server").replace("file://", "")
    property bool serverRunning: false
    property alias topBanner: topBanner
    minimumWidth: 800
    minimumHeight: 600
    title: qsTr("GCompris server")
    color: Style.colorBackground

    onClosing: Server.quit(mainWindow)

    Connections {
        target: databaseController
        onDbError: { errorDialog.message = message; errorDialog.open() }
    }

    Connections {
        target: networkController
        onAddDataToUser: Master.addActivityDataForUser(userId, activityName, rawData)
        onCheckUserPassword: networkController.acceptPassword(Master.checkPassword(login, password), login)
        onStatusChanged: Master.setStatus(userId, newStatus)
    }

    Settings {
        id: serverSettings
        property alias x: mainWindow.x
        property alias y: mainWindow.y
        property alias width: mainWindow.width
        property alias height: mainWindow.height
        property string lastLogin: ""
        property string serverID: "GCompris-Server"
        property bool navigationPanelRight: true
    }

    TopPanel {
        id: topBanner
    }

    NavigationPanel {
        id: navigationBar
        enabled: false
    }

    StackLayout {
        id: mainStack
        anchors {
            top: topBanner.bottom
            bottom: parent.bottom
            right: (serverSettings.navigationPanelRight) ? navigationBar.left : parent.right
            left: (serverSettings.navigationPanelRight) ? parent.left : navigationBar.right
        }
        LoginView {}
        ManagePupilsView {}
        DevicesView {}
        ActivitiesView {}
        ChartsView {}
        SettingsView {}
        DevelopmentView {}
        clip: true
        focus: true

        Keys.onPressed: {
            if (event.modifiers & Qt.MetaModifier) {
                switch (event.key) {
                case Qt.Key_U:
                    navigationBar.startNavigation(navigationBar.pupilsView)
                    break
                case Qt.Key_D:
                    navigationBar.startNavigation(navigationBar.deviceView)
                    break
                case Qt.Key_F:
                    navigationBar.startNavigation(navigationBar.datasView)
                    break
                }
            }
            if (event.modifiers & Qt.ControlModifier) {
                switch (event.key) {
                case Qt.Key_Q:
                    Server.quit()
                    break
//                case Qt.Key_Plus: Style.defaultPixelSize++; console.warn(Style.defaultPixelSize); break
//                case Qt.Key_Minus: Style.defaultPixelSize--; console.warn(Style.defaultPixelSize); break
                }
            }
        }
    }

    ErrorDialog { id: errorDialog }
}
