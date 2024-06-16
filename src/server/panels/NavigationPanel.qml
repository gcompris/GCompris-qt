/* GCompris - NavigationPanel.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12

import "../components"
import "../singletons"

Item {
    id: navigationPanel
    property bool isCollapsed: true
    property int lastIndex: 0
    property alias pupilsView: pupilsView
    property alias deviceView: deviceView
    property alias datasView: datasView
    property alias activityDetails: activityDetails
    property alias chartsView: chartsView
    property alias settingsView: settingsView
    property alias loginButton: loginButton

    anchors {
        top: parent.top
        bottom: parent.bottom
    }
    states: [
        State {
            name: "left"
            when: !serverSettings.navigationPanelRight
            AnchorChanges {
                target: navigationPanel
                anchors.left: parent.left
                anchors.right: undefined
            }
        },
        State {
            name: "right"
            when: serverSettings.navigationPanelRight
            AnchorChanges {
                target: navigationPanel
                anchors.left: undefined
                anchors.right: parent.right
            }
        }
    ]

    width: isCollapsed ? Style.widthNavigationBarCollapsed : Style.widthNavigationBarExpanded
    clip: true

    function changeTo(index) {
        buttons.children[lastIndex + 1].selected = false
        lastIndex = index
        buttons.children[lastIndex + 1].selected = true
        mainStack.currentIndex = lastIndex
        topBanner.text = buttons.children[lastIndex + 1].description
    }

    function startNavigation(button) {
        button.navigationButtonClicked()
    }

    Rectangle {
        anchors.fill: parent
        color: enabled ? Style.colorNavigationBarBackground : Style.colorNavigationBarBackgroundDisabled

        Column {
            id: buttons
            width: parent.width

            NavigationButton {
                iconCharacter: "\uf0c9"
                description: ""
                onNavigationButtonClicked: isCollapsed = !isCollapsed
            }
            NavigationButton {
                id: loginButton
                iconCharacter: "\uf015"
                description: qsTr("GCompris-Server login")
                onNavigationButtonClicked: changeTo(0)
            }
            NavigationButton {
                id: pupilsView
                iconCharacter: "\uf0c0"
                description: qsTr("Managing Pupils")
                onNavigationButtonClicked: changeTo(1)
            }
            NavigationButton {
                id: deviceView
                iconCharacter: "\uf1e6"
                description: qsTr("Connect devices")
                onNavigationButtonClicked: changeTo(2)
            }
            NavigationButton {
                id: activityDetails
                iconCharacter: "\uf03a"
                description: qsTr("Activities view")
                onNavigationButtonClicked: changeTo(3)
            }
            NavigationButton {
                id: chartsView
                iconCharacter: "\uf681"
                description: qsTr("Charts")
                onNavigationButtonClicked: changeTo(4)
            }
            NavigationButton {
                id: settingsView
                iconCharacter: "\uf0ad"
                description: qsTr("Settings")
                onNavigationButtonClicked: changeTo(5)
            }
            NavigationButton {
                id: datasView
                iconCharacter: "\uf188"
                description: qsTr("Development views (work in progress)")
                onNavigationButtonClicked: changeTo(6)
            }

        }
    }
}
