/* GCompris - NavigationPanel.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 * SPDX-FileCopyrightText: 2025 Timothée Giet <animtim@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

import "../components"
import "../singletons"

Item {
    id: navigationPanel
    property bool isCollapsed: true
    property int lastIndex: 0
    property alias pupilsView: pupilsView
    property alias deviceView: deviceView
    property alias activitiesView: activitiesView
    property alias datasetsView: datasetsView
    property alias chartsView: chartsView
    property alias settingsView: settingsView
    property alias devView: devView
    property alias loginButton: loginButton

    height: parent.height
    width: enabled ? buttons.width : 0
    clip: true

    property string currentText: buttons.children[lastIndex + 1].text
    function changeTo(index) {
        buttons.children[lastIndex + 1].checked = false
        lastIndex = index
        buttons.children[lastIndex + 1].checked = true
        mainStack.currentIndex = lastIndex
    }

    function startNavigation(button) {
        if(!enabled) {
            return;
        } else {
            button.clicked();
        }
    }

    Rectangle {
        height: parent.height
        width: buttons.width
        color: Style.selectedPalette.alternateBase

        Column {
            id: buttons
            width: childrenRect.width

            NavigationButton {
                icon.source: "qrc:/gcompris/src/server/resource/icons/menu.svg"
                text: ""
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: buttons.width
                onClicked: navigationPanel.isCollapsed = !navigationPanel.isCollapsed
            }
            NavigationButton {
                id: loginButton
                visible: false // disabled for now, until we support teacher logout and relogin
                icon.source: "qrc:/gcompris/src/server/resource/icons/login.svg"
                text: qsTr("Login")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: buttons.width
                onClicked: navigationPanel.changeTo(0)
            }
            NavigationButton {
                id: pupilsView
                icon.source: "qrc:/gcompris/src/server/resource/icons/users.svg"
                text: qsTr("Pupils and Groups")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: buttons.width
                onClicked: navigationPanel.changeTo(1)
            }
            NavigationButton {
                id: deviceView
                icon.source: "qrc:/gcompris/src/server/resource/icons/connect.svg"
                text: qsTr("Connect devices")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: buttons.width
                onClicked: navigationPanel.changeTo(2)
            }
            NavigationButton {
                id: activitiesView
                icon.source: "qrc:/gcompris/src/server/resource/icons/list.svg"
                text: qsTr("Activities")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: buttons.width
                onClicked: navigationPanel.changeTo(3)
            }
            NavigationButton {
                id: datasetsView
                icon.source: "qrc:/gcompris/src/server/resource/icons/dataset.svg"
                text: qsTr("Datasets")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: buttons.width
                onClicked: navigationPanel.changeTo(4)
            }
            NavigationButton {
                id: chartsView
                icon.source: "qrc:/gcompris/src/server/resource/icons/graph.svg"
                text: qsTr("Charts")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: buttons.width
                onClicked: navigationPanel.changeTo(5)
            }
            NavigationButton {
                id: settingsView
                icon.source: "qrc:/gcompris/src/server/resource/icons/settings.svg"
                text: qsTr("Settings")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: buttons.width
                onClicked: navigationPanel.changeTo(6)
            }
            NavigationButton {
                id: devView
                icon.source: "qrc:/gcompris/src/server/resource/icons/debug.svg"
                text: qsTr("Development (WIP)")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: buttons.width
                onClicked: navigationPanel.changeTo(7)
            }
        }
    }
}
