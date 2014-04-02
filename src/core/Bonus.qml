/* GCompris - Bonus.qml
 *
 * Copyright (C) 2014 Bruno Coudoin
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
import QtQuick 2.2
import GCompris 1.0

Image {
    id: bonus
    visible: true
    opacity: 0
    anchors.fill: parent
    fillMode: Image.Pad
    z: 1000
    scale: ApplicationInfo.ratio

    signal win
    signal loose

    property bool isWin: false

    function good(name) {
        source = "qrc:/gcompris/src/core/resource/bonus/" + name + "_good.png"
        isWin = true;
        animation.start()
    }

    function bad(name) {
        source = "qrc:/gcompris/src/core/resource/bonus/" + name + "_bad.png"
        isWin = false;
        animation.start()
    }

    SequentialAnimation {
        id: animation
        NumberAnimation {
            target: bonus
            property: "opacity"
            from: 0; to: 1.0
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: bonus
            property: "opacity"
            from: 1.0; to: 0
            duration: 500
            easing.type: Easing.InOutQuad
        }
        onStopped: isWin ? win() : loose()
    }
}
