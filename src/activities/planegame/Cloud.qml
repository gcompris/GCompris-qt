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
import GCompris 1.0

Image {
    id: cloud
    property int number

    property Item activity

    sourceSize.height: 100 * ApplicationInfo.ratio

    height: sourceSize.height-20*(activity.currentLevel)

    source: "qrc:/gcompris/src/activities/planegame/resource/cloud.svgz"
    fillMode: Image.PreserveAspectFit

    z: 5

    Text {
        anchors.horizontalCenter: cloud.horizontalCenter
        anchors.verticalCenter: cloud.verticalCenter
        text: number
        color: "black"
        font.bold: true
        font.pointSize: 18
    }

    Component.onCompleted: {
        x = -cloud.width-1
        y = Activity.getRandomInt(0, activity.height - cloud.height)
    }

    Behavior on x { PropertyAnimation { duration: 30*activity.width } }

    Audio {
        id: audioNumber
        onError: { console.log("voice " + source + " play error: " + errorString); }
    }

    function playSound() {
        /* TODO Use QTextCodec or QString toUnicode instead */
        audioNumber.source = ApplicationInfo.getAudioFilePath("voices/$LOCALE/alphabet/U003" + number + ".ogg")
        audioNumber.play()
    }
}
