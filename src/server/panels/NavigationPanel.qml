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

    property string currentText: buttons.children[lastIndex + 1].description
    function changeTo(index) {
        buttons.children[lastIndex + 1].selected = false
        lastIndex = index
        buttons.children[lastIndex + 1].selected = true
        mainStack.currentIndex = lastIndex
    }

    function startNavigation(button) {
        if(!enabled) {
            return;
        } else {
            button.navigationButtonClicked();
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
                iconCharacter: "\uf0c9"
                description: ""
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: navigationPanel.width
                onNavigationButtonClicked: navigationPanel.isCollapsed = !navigationPanel.isCollapsed
            }
            NavigationButton {
                id: loginButton
                visible: false // disabled for now, until we support teacher logout and relogin
                iconCharacter: "\uf015"
                description: qsTr("Login")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: navigationPanel.width
                onNavigationButtonClicked: navigationPanel.changeTo(0)
            }
            NavigationButton {
                id: pupilsView
                iconCharacter: "\uf0c0"
                description: qsTr("Pupils and Groups")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: navigationPanel.width
                onNavigationButtonClicked: navigationPanel.changeTo(1)
            }
            NavigationButton {
                id: deviceView
                iconCharacter: "\uf1e6"
                description: qsTr("Connect devices")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: navigationPanel.width
                onNavigationButtonClicked: navigationPanel.changeTo(2)
            }
            NavigationButton {
                id: activitiesView
                iconCharacter: "\uf03a"
                description: qsTr("Activities")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: navigationPanel.width
                onNavigationButtonClicked: navigationPanel.changeTo(3)
            }
            NavigationButton {
                id: datasetsView
                iconCharacter: "\uf15c"
                description: qsTr("Datasets")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: navigationPanel.width
                onNavigationButtonClicked: navigationPanel.changeTo(4)
            }
            NavigationButton {
                id: chartsView
                iconCharacter: "\uf681"
                description: qsTr("Charts")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: navigationPanel.width
                onNavigationButtonClicked: navigationPanel.changeTo(5)
            }
            NavigationButton {
                id: settingsView
                iconCharacter: "\uf0ad"
                description: qsTr("Settings")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: navigationPanel.width
                onNavigationButtonClicked: navigationPanel.changeTo(6)
            }
            NavigationButton {
                id: devView
                iconCharacter: "\uf188"
                description: qsTr("Development (WIP)")
                isCollapsed: navigationPanel.isCollapsed
                panelWidth: navigationPanel.width
                onNavigationButtonClicked: navigationPanel.changeTo(7)
            }
        }
    }
}
