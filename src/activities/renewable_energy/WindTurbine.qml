/* GCompris - wind.qml
 *
 * SPDX-FileCopyrightText: 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net> (GTK+ version)
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.9
import GCompris 1.0
import "../../core"

Image {
    id: windTurbine
    source: activity.url + "wind/mast.svg"
    sourceSize.width: parent.width * 0.01
    property int duration

    Image {
        id: blade
        source: activity.url + "wind/blade.svg"
        sourceSize.height: parent.height * 1.3
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.top
            verticalCenterOffset: parent.height * 0.06
        }
        
        SequentialAnimation on rotation {
            id: anim
            loops: Animation.Infinite
            running: cloud.started
            NumberAnimation {
                from: 0; to: 360
                duration: windTurbine.duration
            }
        }
    }
}
