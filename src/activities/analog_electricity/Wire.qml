/* GCompris - Wire.qml
 *
 * SPDX-FileCopyrightText: 2020 Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *   Pulkit Gupta <pulkitnsit@gmail.com> (Qt Quick port)
 *   Aiswarya Kaitheri Kandoth <aiswaryakk29@gmail.com> (AnalogElectricity activity)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import GCompris 1.0

import "analog_electricity.js" as Activity

Rectangle {
    id: wire

    property QtObject node1
    property QtObject node2
    property bool destructible

    height: 5 * ApplicationInfo.ratio
    color: Activity.wireColors[node1.colorIndex]
    radius: height / 2
    transformOrigin: Item.Left

    MouseArea {
        id: mouseArea
        enabled: destructible
        width: parent.width
        height: parent.height * 3
        anchors.centerIn: parent
        onPressed: {
            if(Activity.toolDelete) {
                Activity.removeWire(wire);
            }
        }
    }
}
