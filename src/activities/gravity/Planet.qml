/* GCompris - Planet.qml
*
* Copyright (C) 2020 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> and Matilda Bernard (GTK+ version)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (complete activity rewrite)
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
*   along with this program; if not, see <https://www.gnu.org/licenses/>.
*/
import QtQuick 2.6
import GCompris 1.0

import "../../core"
import "gravity.js" as Activity

Image {
    id: planet
    asynchronous: true
    sourceSize.width: undefined
    sourceSize.height: undefined
    z: 5
    y: height * -2
    x: leftSide ? width * -0.5 : parent.width - width * 0.5 
    visible: false
    
    property bool leftSide: true
    property alias fallDuration: down.duration

    function startMoving() {
        down.restart();
    }

    NumberAnimation {
        id: down
        target: planet
        property: "y"
        to: parent.height + height * 2
    }

    Image {
        id: gravityImage
        asynchronous: true
        sourceSize.width: undefined
        sourceSize.height: undefined
        source: Activity.url + "gravity.svg"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: planet.width * 3
        height: width
        z: -1
    }
}
