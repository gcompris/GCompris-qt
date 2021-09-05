/* GCompris - DashboardView.qml
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
    Rectangle {
        anchors.fill: parent
        color: Style.colourBackground
        Column {
            anchors.centerIn: parent
            Image {
                source: 'qrc:/gcompris/src/core/resource/gcompris.png'
            }
            Image {
                source: 'qrc:/gcompris/src/core/resource/aboutkde.png'
            }
            Text {
                text: qsTr("Dashboard")
            }
        }
    }
}
