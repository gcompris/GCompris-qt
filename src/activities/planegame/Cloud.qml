/* gcompris - Cloud.qml

 Copyright (C)
 2003, 2014: Bruno Coudoin: initial version
 2014: Johnny Jazeix: Qt port

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.1
import QtMultimedia 5.0
import "planegame.js" as Activity
import "qrc:/gcompris/src/core"
import GCompris 1.0

Image {
    id: cloud
    property Item background
    property alias text: number.text
    property double heightRatio: 1

    /* An helper property to remember if a cloud has been wrongly touched */
    property bool touched: false

    sourceSize.height: 100 * ApplicationInfo.ratio
    height: sourceSize.height * heightRatio

    source: "qrc:/gcompris/src/activities/planegame/resource/cloud.svgz"
    fillMode: Image.PreserveAspectFit

    z: 5

    signal done

    onDone: {
        particles.emitter.burst(50)
        opacityTimer.start()
    }

    Text {
        id: number
        anchors.horizontalCenter: cloud.horizontalCenter
        anchors.verticalCenter: cloud.verticalCenter
        color: "black"
        font.bold: true
        font.pointSize: 18
    }

    Component.onCompleted: {
        x = -cloud.width - 1
        y = Activity.getRandomInt(0, background.height - cloud.height)
    }

    Behavior on x { PropertyAnimation { duration: 20000 } }
    Behavior on opacity { PropertyAnimation { duration: 400 } }

    Timer {
        id: opacityTimer
        running: false
        repeat: false
        interval: 500
        onTriggered: opacity = 0
    }

    ParticleSystemStar {
        id: particles
        anchors.fill: parent
        clip: false
    }

    Audio {
        id: audioNumber
        onError: { console.log("voice " + source + " play error: " + errorString); }
    }

}
