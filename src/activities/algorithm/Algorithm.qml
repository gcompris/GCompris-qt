/* GCompris - algorithm.qml
 *
 * Copyright (C) 2014 <YOUR NAME HERE>
 *
 * Authors:
 *   <THE GTK VERSION AUTHOR> (GTK+ version)
 *   YOUR NAME <YOUR EMAIL> (Qt Quick port)
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
import QtQuick 2.1
import QtMultimedia 5.0
import GCompris 1.0
import QtQuick.Controls 1.0
import QtQuick.Particles 2.0
import "qrc:/gcompris/src/core"
import "algorithm.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/gcompris/src/activities/algorithm/resource/scenery5_background.png"
        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias algoTray: algoTray
            property alias answerTray: answerTray
            property alias choiceTray: choiceTray
            property alias brick: brick
            property alias bleep: bleep
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        Rect {
            id: algoTray
            x: parent.width/6
            y: parent.height/15
            visible: true
        }

        Rect {
            id: answerTray
            x: parent.width/6
            y: parent.height/4 + 8
        }

        RectHighlight {
            id: choiceTray
            x: parent.width/6
            y: 3*parent.height/4 - 10
        }

        Audio {
            id:brick
            source:"qrc:/gcompris/src/activities/algorithm/resource/brick.wav"
            onError: console.log("brick play error: " + errorString)
        }

        Audio {
            id:bleep
            source: "qrc:/gcompris/src/activities/algorithm/resource/bleep.wav"
            onError: console.log("brick play error: " + errorString)
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | previous | next }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }

}
