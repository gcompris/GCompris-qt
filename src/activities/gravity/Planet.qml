/* GCompris - Planet.qml
*
* SPDX-FileCopyrightText: 2020 Timothée Giet <animtim@gmail.com>
*
* Authors:
*   Bruno Coudoin <bruno.coudoin@gcompris.net> and Matilda Bernard (GTK+ version)
*   Siddhesh suthar <siddhesh.it@gmail.com> (Qt Quick port)
*   Timothée Giet <animtim@gmail.com> (complete activity rewrite)
*
*   SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick 2.12
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
