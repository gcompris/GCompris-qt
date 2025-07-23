/* GCompris - Main.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Bruno ANSELME <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Window
import QtQml
import QtCore // For Settings and StandardPaths

import core 1.0
import "qrc:/gcompris/src/server/server.js" as Server

import "components"
import "dialogs"
import "panels"
import "singletons"
import "views"

/**
 * GCompris Teachers Tool main QML file defining the top level window.
 * @ingroup infrastructure
 *
 * Handles application start (Component.onCompleted) and shutdown (onClosing)
 * on the QML layer.
 *
 * Contains the top level TabContainer presenting and animating GCompris-teachers'
 * full screen views.
 *
 * @inherit QtQuick.Window
 */
Window {
    id: mainWindow
    property string databaseFile: serverSettings.lastLogin + ".sqlite"
    // file:/// is the prefix on Windows, file:// otherwise, both needs to be removed
    readonly property string prefixToRemove: ApplicationInfo.platform === ApplicationInfo.Windows ? "file:///" : "file://"
    property string userDataPath: (StandardPaths.writableLocation(StandardPaths.GenericDataLocation) + "/gcompris-teachers").replace(prefixToRemove, "")
    property bool serverRunning: false
    property alias topBanner: topBanner
    minimumWidth: 800
    minimumHeight: 600
    title: qsTr("GCompris Teachers Tool")
    color: Style.selectedPalette.base

    onClosing: Server.quit(mainWindow)

    Connections {
        target: databaseController
        function onDbError(message) { errorDialog.message = message; errorDialog.open() }
    }

    Connections {
        target: networkController
        function onAddDataToUser(userId, activityName, rawData) { Master.addActivityDataForUser(userId, activityName, rawData) }
        function onCheckUserPassword(login, password) { networkController.acceptPassword(Master.checkPassword(login, password), login) }
        function onStatusChanged(userId, newStatus) { Master.setStatus(userId, newStatus) }
    }

    Settings {
        id: serverSettings
        property alias x: mainWindow.x
        property alias y: mainWindow.y
        property alias width: mainWindow.width
        property alias height: mainWindow.height
        property string lastLogin: ""
        property string serverID: "GCompris-Teachers"
        property string port: "65524"
        property bool navigationPanelRight: true
        property bool darkTheme: true
        onDarkThemeChanged: Style.isDarkTheme = darkTheme
        property int textSize: 16
        onTextSizeChanged: Style.textSize = textSize
    }

    Row {
        id: mainRow
        width: parent.width
        height: parent.height
        layoutDirection: serverSettings.navigationPanelRight ? Qt.LeftToRight : Qt.RightToLeft

        Column {
            width: parent.width - navigationBar.width
            height: parent.height

            TopPanel {
                id: topBanner
            }

            TabContainer {
                id: mainStack
                width: parent.width
                height: parent.height - topBanner.height

                LoginView {}
                ManagePupilsView {
                    visible: false
                }
                DevicesView {
                    visible: false
                }
                ActivitiesView {
                    visible: false
                }
                DatasetsView {
                    visible: false
                }
                ChartsView {
                    visible: false
                }
                SettingsView {
                    visible: false
                }
                DevelopmentView {
                    visible: false
                }
                clip: true
                focus: true

                Keys.onPressed: (event) => {
                    if(event.modifiers & Qt.MetaModifier) {
                        switch (event.key) {
                            case Qt.Key_U:
                                navigationBar.startNavigation(navigationBar.pupilsView)
                                break
                            case Qt.Key_D:
                                navigationBar.startNavigation(navigationBar.deviceView)
                                break
                            case Qt.Key_F:
                                navigationBar.startNavigation(navigationBar.datasetsView)
                                break
                        }
                    } else if(event.modifiers & Qt.ControlModifier) {
                        switch (event.key) {
                            case Qt.Key_Q:
                                Server.quit()
                                break
                        }
                    }
                }
            }
        }

        NavigationPanel {
            id: navigationBar
            enabled: false
        }
    }

    ErrorDialog { id: errorDialog }
}
