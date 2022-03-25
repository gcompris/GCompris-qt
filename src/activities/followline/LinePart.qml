/* GCompris - LinePart.qml
 *
 * SPDX-FileCopyrightText: 2014 Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 * Authors:
 *   Bruno Coudoin <bruno.coudoin@gcompris.net>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick 2.12
import "../../core"
import "followline.js" as Activity

Item {
    id: part
    property QtObject items
    property int index: 0
    property GCSfx audioEffects
    property bool isPart: true

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
                if(part.items.currentLock <= part.index && !Activity.movedOut) {
                    part.items.currentLock = part.index
                    if(part.items.currentLock >= part.items.lastLock) {
                        audioEffects.play("qrc:/gcompris/src/core/resource/sounds/water.wav")
                        items.background.win()
                    } else {
                        Activity.playAudioFx();
                    }
                } else if(part.items.currentLock >= part.index && Activity.movedOut) {
                    items.lineBrokenTimer.stop();
                    Activity.movedOut = false;
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
