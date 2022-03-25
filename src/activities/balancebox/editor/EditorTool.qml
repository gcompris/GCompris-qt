/* GCompris - EditorTool.qml
 *
 * SPDX-FileCopyrightText: 2015 Holger Kaelberer <holger.k@elberer.de>
 *
 * Authors:
 *   Holger Kaelberer <holger.k@elberer.de>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import GCompris 1.0

Item {
    id: root

    property bool highlighted: false
    property bool selected: false
    property int type

    Rectangle {
        id: bounding
        anchors.fill: parent
        radius: 10
        border.width: 2
        border.color: (root.selected || root.highlighted) ? "red" : "black"
        gradient: Gradient {
            GradientStop { position: 0 ; color: root.selected ? "#87ff5c" : "#ffe85c" }
            GradientStop { position: 1 ; color: root.selected ? "#44ff00" : "#f8d600" }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent

        hoverEnabled: ApplicationInfo.isMobile ? false : true
        onEntered: root.highlighted = true
        onExited: root.highlighted = false
        onClicked: root.selected = true
    }
}
