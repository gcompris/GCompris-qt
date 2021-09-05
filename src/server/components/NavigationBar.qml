/* GCompris - NavigationBar.qml
 *
 * SPDX-FileCopyrightText: 2021 Emmanuel Charruau <echarruau@gmail.com>
 *
 * Authors:
 *   Emmanuel Charruau <echarruau@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import "../../core"

Item {
    property bool isCollapsed: true

    anchors {
        top: parent.top
        bottom: parent.bottom
        right: parent.right
    }
    width: isCollapsed ? Style.widthNavigationBarCollapsed : Style.heightNavigationBarExpanded

    Rectangle {
        anchors.fill: parent
        color: Style.colourNavigationBarBackground

        Column {
            width: parent.width

            NavigationButton {
                iconCharacter: "\uf0c9"
                description: ""
                hoverColour: "#993333"
                onNavigationButtonClicked: isCollapsed = !isCollapsed
            }
            NavigationButton {
                iconCharacter: "\uf015"
                description: qsTr("Dashboard")
                hoverColour: "#dc8a00"
                onNavigationButtonClicked: masterController.ui_navigationController.goDashboardView();
            }
            NavigationButton {
                iconCharacter: "\uf1e6"
                description: qsTr("Connecting devices")
                hoverColour: "#dc8a00"
                onNavigationButtonClicked: masterController.ui_navigationController.goDashboardView();
            }
            NavigationButton {
                iconCharacter: "\uf681"
                description: qsTr("Follow results")
                hoverColour: "#dccd00"
                onNavigationButtonClicked: masterController.ui_navigationController.goCreateClientView();
            }
            NavigationButton {
                iconCharacter: "\uf0c0"
                description: qsTr("Managing Pupils")
                hoverColour: "#8aef63"
                onNavigationButtonClicked: masterController.ui_navigationController.goManagePupilsView();
            }
            NavigationButton {
                iconCharacter: "\uf073"
                description: qsTr("Manages Workplane")
                hoverColour: "#8aef63"
                onNavigationButtonClicked: masterController.ui_navigationController.goManageWorkPlanView();
            }
            NavigationButton {
                iconCharacter: "\uf0ae"
                description: qsTr("Manages Sequences")
                hoverColour: "#8aef63"
                onNavigationButtonClicked: masterController.ui_navigationController.goFindClientView();
            }
        }
    }
}
