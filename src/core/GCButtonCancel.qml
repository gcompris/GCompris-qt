/* GCompris - GCButtonCancel.qml
 *
 * Copyright (C) 2015 Bruno Coudoin <bruno.coudoin@gcompris.net>
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
import GCompris 1.0

/**
 * A QML component representing GCompris' cancel button.
 * @ingroup components
 *
 * @inherit QtQuick.Image
 */
Image {
    id: cancel
    source: "qrc:/gcompris/src/core/resource/cancel.svg";
    anchors.right: parent.right
    anchors.top: parent.top
    smooth: true
    sourceSize.width: 60 * ApplicationInfo.ratio
    anchors.margins: 10

    signal close

    SequentialAnimation {
        id: anim
        running: true
        loops: Animation.Infinite
        NumberAnimation {
            target: cancel
            property: "rotation"
            from: -10; to: 10
            duration: 500
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: cancel
            property: "rotation"
            from: 10; to: -10
            duration: 500
            easing.type: Easing.InOutQuad }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: close()
    }
}
