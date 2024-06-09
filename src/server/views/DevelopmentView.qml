/* GCompris - DatasView.qml
 *
 * SPDX-FileCopyrightText: 2024 Bruno Anselme <be.root@free.fr>
 *
 * Authors:
 *   Bruno Anselme <be.root@free.fr>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.15

import "../singletons"
import "../components"
import "../panels"
import "./datas"

Item {
    id: resultView
    property string activityName: ""

    TabBar {
        id: bar
        anchors.top: parent.top
        TabButton {
            text: qsTr("Edit datas")
        }
        TabButton {
            text: qsTr("All requests")
        }
    }

    StackLayout {
        id: contentStack
        width: parent.width
        anchors.top: bar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        currentIndex: bar.currentIndex
        DuplicateData {}
        AllData {}
    }
}
