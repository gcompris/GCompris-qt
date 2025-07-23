/* GCompris - DatasView.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *   Timothée Giet <animtim@gmail.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls.Basic

import "../components"
import "../singletons"
import "datas"

Item {
    id: resultView
    width: parent.width
    height: parent.height

    property string activityName: ""

    Item {
        id: tabButtonsArea
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: Style.lineHeight + Style.bigMargins

        TabBar {
            id: buttonBar
            anchors.fill: parent
            anchors.margins: Style.margins
            background: Item {}
            spacing: Style.margins
            currentIndex: 0

            StyledTabButton {
                text: qsTr("Edit data")
                onClicked: buttonBar.currentIndex = 0;
            }
            StyledTabButton {
                text: qsTr("All requests")
                onClicked: buttonBar.currentIndex = 1;
            }

        }
    }

    TabContainer {
        anchors {
            top: tabButtonsArea.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        currentIndex: buttonBar.currentIndex
        DuplicateData {}
        AllData {
            visible: false
        }
    }
}
