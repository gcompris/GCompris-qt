/* GCompris - LinePart.qml
 *
 * Copyright (C) 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import "../../core"

Item {
    id: part
    property QtObject items
    property int index
    property GCSfx audioEffects

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: - parent.height / 2
        width: parent.width
        height: parent.height * 0.2
        radius: height / 8
        color: "#30354e"
        z: 10
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset: - parent.width * 0.1
        anchors.verticalCenterOffset: 0
        width: parent.width * 1.2
        height: parent.height * 0.9
        radius: height / 4
        z: 5
        color: index < part.items.currentLock
               ? "#3ca7e0"
               : index === part.items.currentLock
                 ? "#dd3128"
                 : "#7A7F8E"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                if(part.items.currentLock == part.index) {
                    part.items.currentLock++
                    if(part.items.currentLock >= part.items.lastLock) {
                        audioEffects.play("qrc:/gcompris/src/core/resource/sounds/water.wav")
                        items.background.win()
                    } else {
                        audioEffects.play("qrc:/gcompris/src/core/resource/sounds/darken.wav")
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: parent.height / 2
        width: parent.width
        height: parent.height * 0.2
        radius: height / 8
        color: "#30354e"
        z: 10
    }
}
